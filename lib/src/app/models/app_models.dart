import '../../core/error/app_exception.dart';

class SampleItem {
  const SampleItem({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;
}

class SampleItemModel extends SampleItem {
  const SampleItemModel({
    required super.id,
    required super.title,
    required super.completed,
  });

  factory SampleItemModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final completed = json['completed'];

    if (id is! int || title is! String || completed is! bool) {
      throw const ParsingException('Sample item has invalid data.');
    }

    return SampleItemModel(id: id, title: title, completed: completed);
  }
}

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class AuthSession {
  const AuthSession({required this.token, this.userName});

  final String token;
  final String? userName;
}

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.token, super.userName});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final user = json['user'];
    final name = user is Map<String, dynamic> ? user['name'] : json['name'];

    if (token is! String || token.isEmpty) {
      throw const ParsingException('Login response has invalid token.');
    }

    return AuthSessionModel(
      token: token,
      userName: name is String ? name : null,
    );
  }
}
