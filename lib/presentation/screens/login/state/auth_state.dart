import 'package:soccer/presentation/common/base_state.dart';

sealed class AuthState extends AppState<void> {
  const AuthState();
}

class AuthInitial extends AppInitial<void> implements AuthState {
  const AuthInitial();
}

class AuthLoading extends AppLoading<void> implements AuthState {
  const AuthLoading();
}

class LoginSuccess extends AppSuccess<void> implements AuthState {
  const LoginSuccess() : super();
}

class RegisterSuccess extends AppSuccess<void> implements AuthState {
  const RegisterSuccess() : super();
}

class AuthFailure extends AppFailure<void> implements AuthState {
  const AuthFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory AuthFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<void>.from(error, stackTrace);
    return AuthFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
