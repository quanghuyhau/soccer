enum AppExceptionType { backend, network, parsing, cancelled, unknown }

class AppException implements Exception {
  const AppException(
    this.message, {
    this.type = AppExceptionType.unknown,
    this.statusCode,
    this.backendCode,
    this.errors,
  });

  const AppException.backend(
    this.message, {
    this.statusCode,
    this.backendCode,
    this.errors,
  }) : type = AppExceptionType.backend;

  const AppException.network(this.message)
    : type = AppExceptionType.network,
      statusCode = null,
      backendCode = null,
      errors = null;

  const AppException.parsing(this.message)
    : type = AppExceptionType.parsing,
      statusCode = null,
      backendCode = null,
      errors = null;

  const AppException.cancelled(this.message)
    : type = AppExceptionType.cancelled,
      statusCode = null,
      backendCode = null,
      errors = null;

  final String message;
  final AppExceptionType type;
  final int? statusCode;
  final int? backendCode;
  final Map<String, dynamic>? errors;

  bool get isBackendError => type == AppExceptionType.backend;
  bool get isNetworkError => type == AppExceptionType.network;

  @override
  String toString() => message;
}
