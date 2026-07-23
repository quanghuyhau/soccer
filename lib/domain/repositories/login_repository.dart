import 'package:soccer/domain/entities/app_models.dart';

abstract interface class AuthRepository {
  Future<AuthTokens> login(LoginRequest request);
  Future<AppUser> register(RegisterRequest request);
  Future<AppUser> getCurrentUser({String? accessToken});
}
