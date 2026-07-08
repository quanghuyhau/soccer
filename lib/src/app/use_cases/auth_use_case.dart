import '../models/app_models.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  const AuthUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionData> login(LoginRequest request) async {
    final tokens = await _repository.login(request);
    final user = await _repository.getCurrentUser(
      accessToken: tokens.accessToken,
    );

    return AuthSessionData(tokens: tokens, user: user);
  }

  Future<AppUser> register(RegisterRequest request) {
    return _repository.register(request);
  }

  Future<AppUser> getCurrentUser({String? accessToken}) {
    return _repository.getCurrentUser(accessToken: accessToken);
  }
}
