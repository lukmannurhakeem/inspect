/// Base type for every exception the app throws intentionally.
///
/// Every custom exception below extends this, so a single `catch (e)`
/// anywhere above the repository layer can treat `e` as an [AppException]
/// and read a safe, user-facing [message] - see [ErrorHandler].
sealed class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

/// No internet / DNS failure / socket errors.
class NetworkException extends AppException {
  const NetworkException(
      [super.message = 'No internet connection. Please check your network.']);
}

/// Connect or receive timeout.
class TimeoutException extends AppException {
  const TimeoutException(
      [super.message = 'The request timed out. Please try again.']);
}

/// 400 - malformed / invalid request.
class BadRequestException extends AppException {
  final int? statusCode;
  const BadRequestException(super.message, [this.statusCode]);
}

/// 401 / 403.
class UnauthorizedException extends AppException {
  const UnauthorizedException(
      [super.message = 'You are not authorized to perform this action.']);
}

/// 404.
class NotFoundException extends AppException {
  const NotFoundException(
      [super.message = 'The requested resource was not found.']);
}

/// 5xx.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, [this.statusCode]);
}

/// JSON that didn't match what a Freezed model expected.
class DataParsingException extends AppException {
  const DataParsingException(
      [super.message =
          'Failed to process the data received from the server.']);
}

/// Catch-all fallback so nothing ever leaks a raw, unhandled error to the UI.
class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong. Please try again.']);
}
