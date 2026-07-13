import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../app/use_cases/app_use_case.dart';
import '../../core/state/app_state.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AppState<void>>((ref) {
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AppState<void>> {
  AuthController(this._ref) : super(const AppState.initial());

  final Ref _ref;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AppState.loading();

    state = await AppState.guard(() async {
      final session = await _ref
          .read(appUseCaseProvider)
          .auth
          .login(LoginRequest(username: username.trim(), password: password));
      _ref.read(appSessionProvider.notifier).setSession(session);
    });
  }

  Future<void> register({
    required String username,
    required String password,
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    state = const AppState.loading();

    state = await AppState.guard(() async {
      await _ref
          .read(appUseCaseProvider)
          .auth
          .register(
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
    });
  }
}
