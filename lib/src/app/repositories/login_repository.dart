import '../models/app_models.dart';

abstract interface class LoginRepository {
  Future<LoginResponse> login(LoginRequest request);
}
