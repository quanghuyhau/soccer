import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import 'api_method.dart';
import 'api_response.dart';
import 'backend_error_mapper.dart';
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
      throw AppException.parsing(error.toString());
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

    throw const AppException.parsing('Response data is not a JSON object.');
  }

  List<dynamic> _parseJsonList(Object? data) {
    if (data is List<dynamic>) {
      return data;
    }

    throw const AppException.parsing('Response data is not a JSON array.');
  }

  AppException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const AppException.cancelled('Request was cancelled.');
    }

    final response = error.response;

    if (response != null) {
      final statusCode = response.statusCode;

      return BackendErrorMapper.fromResponseBody(
        response.data,
        httpStatusCode: statusCode,
        fallbackMessage: response.statusMessage ?? 'Server error.',
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppException.network('Connection timeout.');
    }

    return AppException.network(error.message ?? 'Network error.');
  }
}
