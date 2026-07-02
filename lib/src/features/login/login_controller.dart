import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/use_cases/app_use_case.dart';

final loginControllerProvider =
    StateNotifierProvider.autoDispose<
      LoginController,
      AsyncValue<LoginResponse?>
    >((ref) {
      return LoginController(ref);
    });

class LoginController extends StateNotifier<AsyncValue<LoginResponse?>> {
  LoginController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    final request = LoginRequest(email: email.trim(), password: password);

    state = await AsyncValue.guard(() {
      return _ref.read(appUseCaseProvider).login(request);
    });
  }
}
