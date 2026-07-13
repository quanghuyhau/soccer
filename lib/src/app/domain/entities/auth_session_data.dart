import 'app_user.dart';
import 'auth_tokens.dart';

class AuthSessionData {
  const AuthSessionData({required this.tokens, required this.user});

  final AuthTokens tokens;
  final AppUser user;
}
