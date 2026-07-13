import '../error/app_exception.dart';

class BackendErrorCode {
  const BackendErrorCode._();

  static const unknown = 9999;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const validation = 422;
}

class BackendErrorMapper {
  const BackendErrorMapper._();

  static AppException fromResponseBody(
    Object? data, {
    int? httpStatusCode,
    String? fallbackMessage,
  }) {
    final code = _extractCode(data);
    final message =
        _extractMessage(data) ?? fallbackMessage ?? 'Có lỗi xảy ra.';
    final errors = _extractErrors(data);

    return fromCode(
      code,
      message: message,
      httpStatusCode: httpStatusCode,
      errors: errors,
    );
  }

  static AppException fromCode(
    int? code, {
    required String message,
    int? httpStatusCode,
    Map<String, dynamic>? errors,
  }) {
    return switch (code ?? httpStatusCode) {
      BackendErrorCode.badRequest => BadRequestException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
      ),
      BackendErrorCode.unauthorized => UnauthorizedException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
      ),
      BackendErrorCode.forbidden => ForbiddenException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
      ),
      BackendErrorCode.notFound => NotFoundException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
      ),
      BackendErrorCode.validation => ValidationException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        errors: errors,
      ),
      _ => ServerException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
      ),
    };
  }

  static int? _extractCode(Object? data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      if (code is int) {
        return code;
      }
      if (code is String) {
        return int.tryParse(code);
      }
    }

    return null;
  }

  static String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }

  static Map<String, dynamic>? _extractErrors(Object? data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors;
      }
    }

    return null;
  }
}
