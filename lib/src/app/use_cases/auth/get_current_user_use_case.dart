import '../../models/app_models.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call() {
    return _repository.getCurrentUser();
  }
}
