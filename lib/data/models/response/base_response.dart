class BaseResponse<T> {
  BaseResponse({
    this.result,
    this.code,
    this.message,
    this.success,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponse(
      result: json['result'] != null ? fromJsonT(json['result']) : null,
      code: json['code'] as int?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }

  final T? result;
  final int? code;
  final String? message;
  final bool? success;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'result': result != null ? toJsonT(result as T) : null,
      'code': code,
      'message': message,
      'success': success,
    };
  }
}
