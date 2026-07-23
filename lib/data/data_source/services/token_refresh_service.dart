import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/api_envelope_parser.dart';
import 'package:soccer/data/data_source/services/app_endpoints.dart';
import 'package:soccer/data/data_source/services/backend_error_mapper.dart';
import 'package:soccer/data/models/request/auth_request.dart';
import 'package:soccer/data/models/response/auth_response.dart';
import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/utilities/utils/app_exception.dart';

@lazySingleton
class TokenRefreshService {
  TokenRefreshService(AppConfig config)
    : _dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: const {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

  // Dùng Dio riêng, không gắn AppInterceptor, để refresh-token không tự gọi lại chính nó.
  final Dio _dio;

  Future<AuthTokensResponse> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Object?>(
        AppEndpoints.authRefreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );
      final result = parseApiObject(response.data);

      return AuthTokensResponse.fromJson(result);
    } on AppException {
      rethrow;
    } on DioException catch (error) {
      throw BackendErrorMapper.fromResponseBody(
        error.response?.data,
        httpStatusCode: error.response?.statusCode,
        fallbackMessage:
            error.response?.statusMessage ??
            'Không thể làm mới phiên đăng nhập.',
      );
    } catch (error) {
      throw AppException.parsing(error.toString());
    }
  }
}
