import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/errors/error_handler.dart';
import 'package:inspect/storage/token_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'auth_interceptor.dart';

class ApiClient {
  ApiClient({
    String? baseUrl,
    Dio? dio,
    TokenStorage? tokenStorage,
    VoidCallback? onSessionExpired,
  }) : _dio =
      dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          ) {
    _dio.transformer = BackgroundTransformer();

    if (tokenStorage != null) {
      _dio.interceptors.add(
        AuthInterceptor(
          storage: tokenStorage,
          dio: _dio,
          onSessionExpired: onSessionExpired ?? () {},
        ),
      );
    }

    // Logger goes last so it prints the final request, including headers.
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
  }

  final Dio _dio;

  Dio get raw => _dio;

  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        T Function(dynamic data)? parser,
      }) =>
      _request(() => _dio.get(path, queryParameters: queryParameters), parser);

  Future<T> post<T>(
      String path, {
        dynamic data,
        T Function(dynamic data)? parser,
      }) => _request(() => _dio.post(path, data: data), parser);

  Future<T> put<T>(
      String path, {
        dynamic data,
        T Function(dynamic data)? parser,
      }) => _request(() => _dio.put(path, data: data), parser);

  Future<T> patch<T>(
      String path, {
        dynamic data,
        T Function(dynamic data)? parser,
      }) => _request(() => _dio.patch(path, data: data), parser);

  Future<T> delete<T>(
      String path, {
        dynamic data,
        T Function(dynamic data)? parser,
      }) => _request(() => _dio.delete(path, data: data), parser);

  Future<T> _request<T>(
      Future<Response<dynamic>> Function() call,
      T Function(dynamic data)? parser,
      ) async {
    try {
      final response = await call();
      final data = response.data;
      if (parser == null) return data as T;
      return await compute(parser, data);
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }
}