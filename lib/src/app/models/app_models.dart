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

class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.userId,
    this.userName,
  });

  final String token;
  final int userId;
  final String? userName;
}

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.token,
    required super.userId,
    super.userName,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] ?? 'demo-token-${json['id']}';
    final id = json['id'] ?? json['userId'];
    final user = json['user'];
    final name = user is Map<String, dynamic>
        ? user['name']
        : json['name'] ?? json['email'];

    if (token is! String || token.isEmpty || id is! int) {
      throw const ParsingException('Login response has invalid token.');
    }

    return LoginResponseModel(
      token: token,
      userId: id,
      userName: name is String ? name : null,
    );
  }
}
