sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode, this.backendCode});

  final String message;
  final int? statusCode;
  final int? backendCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class BadRequestException extends AppException {
  const BadRequestException(
    super.message, {
    super.statusCode,
    super.backendCode,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(
    super.message, {
    super.statusCode,
    super.backendCode,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException(
    super.message, {
    super.statusCode,
    super.backendCode,
  });
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.statusCode, super.backendCode});
}

class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.statusCode,
    super.backendCode,
    this.errors,
  });

  final Map<String, dynamic>? errors;
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode, super.backendCode});
}

class ParsingException extends AppException {
  const ParsingException(super.message);
}

class CancelledException extends AppException {
  const CancelledException(super.message);
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}
