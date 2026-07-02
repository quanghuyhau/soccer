import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import 'api_method.dart';
import 'api_response.dart';
import 'dio_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> request<T>(
    String path, {
    ApiMethod method = ApiMethod.get,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(Object? data)? parser,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(method: method.name),
      );

      final parsedData = parser == null
          ? response.data as T
          : parser(response.data);

      return ApiResponse<T>(
        data: parsedData,
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on AppException {
      rethrow;
    } catch (error) {
      throw ParsingException(error.toString());
    }
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await request<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      parser: _parseJsonObject,
    );

    return response.data;
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await request<List<dynamic>>(
      path,
      queryParameters: queryParameters,
      parser: _parseJsonList,
    );

    return response.data;
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
  }) {
    return request<T>(path, queryParameters: queryParameters, parser: parser);
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
  }) {
    return request<T>(
      path,
      method: ApiMethod.post,
      data: data,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
  }) {
    return request<T>(
      path,
      method: ApiMethod.put,
      data: data,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
  }) {
    return request<T>(
      path,
      method: ApiMethod.patch,
      data: data,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
  }) {
    return request<T>(
      path,
      method: ApiMethod.delete,
      data: data,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  Map<String, dynamic> _parseJsonObject(Object? data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    throw const ParsingException('Response data is not a JSON object.');
  }

  List<dynamic> _parseJsonList(Object? data) {
    if (data is List<dynamic>) {
      return data;
    }

    throw const ParsingException('Response data is not a JSON array.');
  }

  AppException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const CancelledException('Request was cancelled.');
    }

    final response = error.response;

    if (response != null) {
      final statusCode = response.statusCode;
      final message =
          _extractMessage(response.data) ??
          response.statusMessage ??
          'Server error.';

      return switch (statusCode) {
        400 => BadRequestException(message, statusCode: statusCode),
        401 => UnauthorizedException(message, statusCode: statusCode),
        403 => ForbiddenException(message, statusCode: statusCode),
        404 => NotFoundException(message, statusCode: statusCode),
        422 => ValidationException(
          message,
          statusCode: statusCode,
          errors: _extractErrors(response.data),
        ),
        _ => ServerException(message, statusCode: statusCode),
      };
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException('Connection timeout.');
    }

    return NetworkException(error.message ?? 'Network error.');
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractErrors(Object? data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors;
      }
    }

    return null;
  }
}
