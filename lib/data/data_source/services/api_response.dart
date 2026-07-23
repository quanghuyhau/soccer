class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    required this.statusCode,
    this.message,
  });

  final T data;
  final int? statusCode;
  final String? message;
}
