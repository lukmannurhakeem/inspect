import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'api_endpoint.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.storage,
    required this.dio,
    required this.onSessionExpired,
  });

  final TokenStorage storage;
  final Dio dio;
  final VoidCallback onSessionExpired;

  static final _publicPaths = [ApiEndpoint.login, ApiEndpoint.refreshToken];

  bool _isPublic(RequestOptions o) =>
      _publicPaths.any((p) => o.path.contains(p));

  Dio _cleanDio() => Dio(BaseOptions(baseUrl: dio.options.baseUrl));

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (!_isPublic(options)) {
      final token = await storage.token;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('[Auth] No token for ${options.path}');
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final req = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        _isPublic(req) ||
        req.extra['retried'] == true) {
      return handler.next(err);
    }

    try {
      final currentAccess = await storage.token;
      final usedToken = req.headers['Authorization']?.toString().replaceFirst(
        'Bearer ',
        '',
      );

      if (currentAccess != null &&
          currentAccess.isNotEmpty &&
          currentAccess != usedToken) {
        return handler.resolve(await _retry(req, currentAccess));
      }

      final refresh = await storage.refreshToken;
      final expiry = await storage.refreshExpiry;
      if (refresh == null ||
          refresh.isEmpty ||
          (expiry != null && expiry.isBefore(DateTime.now()))) {
        throw StateError('Refresh token missing or expired');
      }

      final res = await _cleanDio().post(
        ApiEndpoint.refreshToken,
        data: {'refresh_token': refresh},
      );

      final body = res.data as Map<String, dynamic>;
      final newAccess = body['access_token'] as String;
      final newRefresh = (body['refresh_token'] as String?) ?? refresh;

      await storage.saveTokens(
        token: newAccess,
        refreshToken: newRefresh,
        refreshExpiry: DateTime.now().add(const Duration(days: 30)),
      );

      handler.resolve(await _retry(req, newAccess));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await storage.clearTokens();
        onSessionExpired();
      }
      handler.next(e.requestOptions.path == req.path ? e : err);
    } catch (_) {
      await storage.clearTokens();
      onSessionExpired();
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions req, String token) {
    req.headers['Authorization'] = 'Bearer $token';
    req.extra['retried'] = true;
    return _cleanDio().fetch(req);
  }
}