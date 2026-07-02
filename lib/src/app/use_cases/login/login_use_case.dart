import '../../../core/usecase/usecase.dart';
import '../../models/app_models.dart';
import '../../repositories/login_repository.dart';

class LoginUseCase implements UseCase<LoginResponse, LoginRequest> {
  const LoginUseCase(this._repository);

  final LoginRepository _repository;

  @override
  Future<LoginResponse> call(LoginRequest input) {
    return _repository.login(input);
  }
}
