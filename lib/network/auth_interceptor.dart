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
  final void Function(String? message) onSessionExpired;

  static final _publicPaths = [ApiEndpoint.login, ApiEndpoint.refreshToken];

  bool _isPublic(RequestOptions o) =>
      _publicPaths.any((p) => o.path.contains(p));

  Dio _cleanDio() => Dio(BaseOptions(baseUrl: dio.options.baseUrl));

  String? _messageOf(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  Future<void> _expireSession([String? message]) async {
    await storage.clearTokens();
    try {
      onSessionExpired(message);
    } catch (e, st) {
      debugPrint('[Auth] onSessionExpired failed: $e\n$st');
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublic(options)) return handler.next(options);

    final token = await storage.token;
    if (token == null || token.isEmpty) {
      final refresh = await storage.refreshToken;
      if (refresh == null || refresh.isEmpty) {
        await _expireSession();
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: options, statusCode: 401),
          ),
        );
      }
      debugPrint('[Auth] No access token for ${options.path}, refresh pending');
      return handler.next(options);
    }

    options.headers['Authorization'] = 'Bearer $token';
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
      final refresh = await storage.refreshToken;
      final hasAccess = currentAccess?.isNotEmpty == true;
      final hasRefresh = refresh?.isNotEmpty == true;

      if (!hasAccess && !hasRefresh) {
        await _expireSession(_messageOf(err.response));
        return handler.next(err);
      }

      final usedToken = req.headers['Authorization']?.toString().replaceFirst(
        'Bearer ',
        '',
      );

      if (hasAccess && currentAccess != usedToken) {
        return handler.resolve(await _retry(req, currentAccess!));
      }

      final expiry = await storage.refreshExpiry;
      if (!hasRefresh || (expiry != null && expiry.isBefore(DateTime.now()))) {
        throw StateError('Refresh token missing or expired');
      }

      final res = await _cleanDio().post(
        ApiEndpoint.refreshToken,
        data: {'refresh_token': refresh},
      );

      final body = res.data as Map<String, dynamic>;
      final newAccess = body['access_token'] as String;
      final newRefresh = (body['refresh_token'] as String?) ?? refresh!;

      await storage.saveTokens(
        token: newAccess,
        refreshToken: newRefresh,
        refreshExpiry: DateTime.now().add(const Duration(days: 30)),
      );

      handler.resolve(await _retry(req, newAccess));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _expireSession(
          _messageOf(e.response) ?? _messageOf(err.response),
        );
      }
      handler.next(err);
    } catch (_) {
      await _expireSession(_messageOf(err.response));
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions req, String token) {
    req.headers['Authorization'] = 'Bearer $token';
    req.extra['retried'] = true;
    return _cleanDio().fetch(req);
  }
}
