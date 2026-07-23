import 'package:soccer/domain/entities/app_user.dart';
import 'package:soccer/domain/entities/auth_tokens.dart';

class AuthSessionData {
  const AuthSessionData({required this.tokens, required this.user});

  final AuthTokens tokens;
  final AppUser user;
}
