import '../../models/app_models.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser> getCurrentUser({String? accessToken}) {
    return _repository.getCurrentUser(accessToken: accessToken);
  }
}
