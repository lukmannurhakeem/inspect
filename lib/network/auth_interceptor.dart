import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'api_endpoint.dart';

/// Attaches the bearer token to every request and, on a 401, refreshes
/// the token once and retries the original request.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.storage,
    required this.dio,
    required this.onSessionExpired,
  });

  final TokenStorage storage;
  final Dio dio;
  final VoidCallback onSessionExpired;

  // Endpoints that must NOT get a token or trigger a refresh.
  static final _publicPaths = [ApiEndpoint.login, ApiEndpoint.refreshToken];

  bool _isPublic(RequestOptions o) =>
      _publicPaths.any((p) => o.path.contains(p));

  /// Interceptor-free Dio for the refresh call and the retry, so neither
  /// can loop back into this interceptor or deadlock its error queue.
  Dio _cleanDio() => Dio(BaseOptions(baseUrl: dio.options.baseUrl));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options)) {
      final token = await storage.token;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
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

      if (currentAccess != null && currentAccess != usedToken) {
        return handler.resolve(await _retry(req, currentAccess));
      }

      final refresh = await storage.refreshToken;
      final expiry = await storage.refreshExpiry;
      if (refresh == null ||
          (expiry != null && expiry.isBefore(DateTime.now()))) {
        throw StateError('Refresh token missing or expired');
      }

      final res = await _cleanDio().post(
        ApiEndpoint.refreshToken,
        data: {'accessToken': currentAccess ?? '', 'refreshToken': refresh},
      );

      final body = res.data as Map<String, dynamic>;
      if (body['isSuccess'] != true) {
        throw StateError('Refresh failed');
      }

      final r = body['result'] as Map<String, dynamic>;
      final newAccess = r['token'] as String;
      final newRefresh = r['refreshToken'] as String;
      final newExpiry = DateTime.parse(r['refreshTokenExpiryTime'] as String);

      await storage.saveTokens(
        token: newAccess,
        refreshToken: newRefresh,
        refreshExpiry: newExpiry,
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
