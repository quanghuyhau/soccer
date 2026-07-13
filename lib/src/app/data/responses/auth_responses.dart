import '../../../core/error/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_tokens.dart';
import 'json_value.dart';

class AuthTokensResponse extends AuthTokens {
  const AuthTokensResponse({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensResponse.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];

    if (accessToken is! String || refreshToken is! String) {
      throw const AppException.parsing(
        'Login response has invalid token data.',
      );
    }

    return AuthTokensResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

class AppUserResponse extends AppUser {
  const AppUserResponse({
    required super.id,
    required super.username,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.status,
    required super.roles,
    super.gender,
    super.dateOfBirth,
    super.address,
  });

  factory AppUserResponse.fromJson(Map<String, dynamic> json) {
    return AppUserResponse(
      id: jsonString(json['id']),
      username: jsonString(json['username']),
      fullName: jsonString(json['fullName']),
      email: jsonString(json['email']),
      phone: jsonString(json['phone']),
      status: jsonString(json['status'], fallback: 'ACTIVE'),
      roles: jsonStringList(json['roles']),
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
    );
  }
}
