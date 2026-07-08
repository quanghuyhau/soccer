import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/app_models.dart';
import 'api_envelope_parser.dart';
import 'app_endpoints.dart';

class AuthDataSource {
  const AuthDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensModel> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.authLogin,
      data: request.toJson(),
      parser: parseJsonObject,
    );
    return AuthTokensModel.fromJson(readResultObject(response.data));
  }

  Future<AppUserModel> register(RegisterRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.authRegister,
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return AppUserModel.fromJson(readResultObject(response.data));
  }

  Future<AppUserModel> getCurrentUser({String? accessToken}) async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      AppEndpoints.currentUser,
      parser: parseJsonObject,
      options: accessToken == null || accessToken.isEmpty
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return AppUserModel.fromJson(readResultObject(response.data));
  }
}
