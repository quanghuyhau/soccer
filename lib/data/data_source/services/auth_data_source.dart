import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/api_client.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/data/data_source/services/api_envelope_parser.dart';
import 'package:soccer/data/data_source/services/app_endpoints.dart';

@lazySingleton
class AuthDataSource {
  const AuthDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensResponse> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.authLogin,
      data: request.toJson(),
      parser: parseApiObject,
    );
    return AuthTokensResponse.fromJson(response.data);
  }

  Future<AppUserResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.authRegister,
      data: request.toJson(),
      parser: parseApiObject,
    );

    return AppUserResponse.fromJson(response.data);
  }

  Future<AppUserResponse> getCurrentUser({String? accessToken}) async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      AppEndpoints.currentUser,
      parser: parseApiObject,
      options: accessToken == null || accessToken.isEmpty
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return AppUserResponse.fromJson(response.data);
  }
}
