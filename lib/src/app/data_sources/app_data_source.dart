import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/app_models.dart';

final appDataSourceProvider = Provider<AppDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AppDataSource(
    home: HomeDataSource(apiClient),
    login: LoginDataSource(apiClient),
  );
});

class AppDataSource {
  const AppDataSource({required this.home, required this.login});

  final HomeDataSource home;
  final LoginDataSource login;
}

class HomeDataSource {
  const HomeDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SampleItemModel> getSampleItem() async {
    final json = await _apiClient.getJson('/todos/1');
    return SampleItemModel.fromJson(json);
  }
}

class LoginDataSource {
  const LoginDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionModel> login(LoginRequest request) async {
    final response = await _apiClient.post<AuthSessionModel>(
      '/login',
      data: request.toJson(),
      parser: (data) => AuthSessionModel.fromJson(_asJsonObject(data)),
    );

    return response.data;
  }
}

Map<String, dynamic> _asJsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  throw const ParsingException('Response data is not a JSON object.');
}
