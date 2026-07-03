import '../../models/app_models.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call(RegisterRequest request) {
    return _repository.register(request);
  }
}
