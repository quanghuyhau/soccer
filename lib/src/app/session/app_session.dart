import 'package:flutter_riverpod/legacy.dart';

import '../models/app_models.dart';

final appSessionProvider =
    StateNotifierProvider<AppSessionController, AuthSessionData?>((ref) {
      return AppSessionController();
    });

class AppSessionController extends StateNotifier<AuthSessionData?> {
  AppSessionController() : super(null);

  void setSession(AuthSessionData session) {
    state = session;
  }

  void clear() {
    state = null;
  }
}
