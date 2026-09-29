import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Central, single place that turns *anything* thrown - a [DioException],
/// a JSON parsing [FormatException], or a genuinely unexpected error -
/// into one of our typed [AppException]s.
///
/// Every repository/service `catch` block should funnel through
/// [ErrorHandler.handle] so the presentation layer only ever has to deal
/// with [AppException], never raw Dio/plugin exceptions.
class ErrorHandler {
  ErrorHandler._();

  static AppException handle(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;

    if (error is DioException) return _fromDioException(error);

    if (error is FormatException) return DataParsingException('$error');

    return UnknownException('$error');
  }

  static AppException _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badCertificate:
        return const NetworkException(
            'A secure connection could not be established.');
      case DioExceptionType.cancel:
        return const UnknownException('The request was cancelled.');
      case DioExceptionType.badResponse:
        return _fromStatusCode(error.response?.statusCode, error.response?.data);
      case DioExceptionType.unknown:
        return const NetworkException();
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static AppException _fromStatusCode(int? code, dynamic data) {
    final message = _extractMessage(data);
    switch (code) {
      case 400:
        return BadRequestException(message ?? 'Invalid request.', code);
      case 401:
      case 403:
        return UnauthorizedException(
            message ?? 'You are not authorized to perform this action.');
      case 404:
        return NotFoundException(message ?? 'The requested resource was not found.');
      default:
        if (code != null && code >= 500) {
          return ServerException(message ?? 'Server error. Please try again later.', code);
        }
        return UnknownException(message ?? 'Something went wrong. (status: $code)');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) return data['message'] as String;
    return null;
  }
}
