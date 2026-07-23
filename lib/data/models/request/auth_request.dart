class LoginRequest {
  const LoginRequest({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}

class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
  });

  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
    };
  }
}
