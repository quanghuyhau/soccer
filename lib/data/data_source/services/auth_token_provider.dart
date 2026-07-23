import 'package:soccer/domain/entities/auth_tokens.dart';

typedef AccessTokenReader = Future<String?> Function();
typedef RefreshTokenReader = Future<String?> Function();
typedef TokenUpdater = Future<void> Function(AuthTokens tokens);
typedef SessionClearer = Future<void> Function();

class AuthTokenProvider {
  const AuthTokenProvider({
    required AccessTokenReader readAccessToken,
    required RefreshTokenReader readRefreshToken,
    required TokenUpdater updateTokens,
    required SessionClearer clearSession,
  }) : _readAccessToken = readAccessToken,
       _readRefreshToken = readRefreshToken,
       _updateTokens = updateTokens,
       _clearSession = clearSession;

  final AccessTokenReader _readAccessToken;
  final RefreshTokenReader _readRefreshToken;
  final TokenUpdater _updateTokens;
  final SessionClearer _clearSession;

  Future<String?> getToken() async {
    return _readAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return _readRefreshToken();
  }

  Future<void> updateTokens(AuthTokens tokens) {
    return _updateTokens(tokens);
  }

  Future<void> clearSession() {
    return _clearSession();
  }
}
