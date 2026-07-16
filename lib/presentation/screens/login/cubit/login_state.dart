part of 'login_cubit.dart';

abstract class LoginState {}

class Initial extends LoginState {}

class Loading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError(this.errorMessage);
}
