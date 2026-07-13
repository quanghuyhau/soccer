import '../error/app_exception.dart';
import '../../app/errors/auth_error_type.dart';

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
    final reason = AuthErrorClassifier.from(code: code, message: message);

    return fromCode(
      code,
      message: message,
      httpStatusCode: httpStatusCode,
      errors: errors,
      reason: reason,
    );
  }

  static AppException fromCode(
    int? code, {
    required String message,
    int? httpStatusCode,
    Map<String, dynamic>? errors,
    Object? reason,
  }) {
    final resolvedReason = reason ?? reasonOf(code: code, message: message);

    return switch (code ?? httpStatusCode) {
      BackendErrorCode.badRequest => BadRequestException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
      ),
      BackendErrorCode.unauthorized => UnauthorizedException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
      ),
      BackendErrorCode.forbidden => ForbiddenException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
      ),
      BackendErrorCode.notFound => NotFoundException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
      ),
      BackendErrorCode.validation => ValidationException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
        errors: errors,
      ),
      _ => ServerException(
        message,
        statusCode: httpStatusCode,
        backendCode: code,
        reason: resolvedReason,
      ),
    };
  }

  static Object? reasonOf({required int? code, required String message}) {
    return AuthErrorClassifier.from(code: code, message: message);
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
