import '../../models/app_models.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionData> call(LoginRequest request) async {
    final tokens = await _repository.login(request);
    final user = await _repository.getCurrentUser(
      accessToken: tokens.accessToken,
    );

    return AuthSessionData(tokens: tokens, user: user);
  }
}
