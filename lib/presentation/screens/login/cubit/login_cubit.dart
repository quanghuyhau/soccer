import 'package:atm_soundbox/domain/use_cases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
  })  : _loginUseCase = loginUseCase,
        super(Initial());

  final LoginUseCase _loginUseCase;

  login(String branchId, String username, String password) async {
    emit(Loading());

    try {
      final response =
          await _loginUseCase.login(userName: username, password: password);
      if (response?.success == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginError(''));
      }
    } catch (e) {
      emit(LoginError(''));
    }
  }
}
