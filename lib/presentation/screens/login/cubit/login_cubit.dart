import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/login/state/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AppUseCase useCase,
    required AppSessionCubit sessionCubit,
  }) : _useCase = useCase,
       _sessionCubit = sessionCubit,
       super(const AuthInitial());

  final AppUseCase _useCase;
  final AppSessionCubit _sessionCubit;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final session = await _useCase.auth.login(
        LoginRequest(username: username.trim(), password: password),
      );
      _sessionCubit.setSession(session);
      emit(const LoginSuccess());
    } catch (error, stackTrace) {
      emit(AuthFailure.from(error, stackTrace));
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    emit(const AuthLoading());

    try {
      await _useCase.auth.register(
        RegisterRequest(
          username: username.trim(),
          password: password,
          fullName: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          gender: 'MALE',
          dateOfBirth: '2002-05-11',
          address: address.trim(),
        ),
      );
      emit(const RegisterSuccess());
    } catch (error, stackTrace) {
      emit(AuthFailure.from(error, stackTrace));
    }
  }
}
