import 'package:injectable/injectable.dart';
import 'package:soccer/domain/repositories/login_repository.dart';

@injectable
class LoginUseCase {
  final LoginRepository _loginRepository;

  LoginUseCase({
    required LoginRepository loginRepository,
  }) : _loginRepository = loginRepository;

  Future login({String? userName, String? password}) async {
    return _loginRepository.login(userName: userName, password: password);
  }
}
