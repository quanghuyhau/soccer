import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session/app_session.dart';

final authTokenProvider = Provider<AuthTokenProvider>((ref) {
  return AuthTokenProvider(ref);
});

class AuthTokenProvider {
  const AuthTokenProvider(this._ref);

  final Ref _ref;

  Future<String?> getToken() async {
    return _ref.read(appSessionProvider)?.tokens.accessToken;
  }
}
