import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/app_models.dart';

@lazySingleton
class AppSessionCubit extends Cubit<AuthSessionData?> {
  AppSessionCubit() : super(null);

  void setSession(AuthSessionData session) {
    emit(session);
  }

  void updateTokens(AuthTokens tokens) {
    final currentSession = state;
    if (currentSession == null) {
      return;
    }

    emit(AuthSessionData(tokens: tokens, user: currentSession.user));
  }

  void clear() {
    emit(null);
  }
}
