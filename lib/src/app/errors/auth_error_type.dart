enum AuthErrorType {
  uncategorizedException,
  invalidRequest,
  usernameExisted,
  emailExisted,
  phoneExisted,
  userNotFound,
  roleNotFound,
  invalidUsernameOrPassword,
  unauthenticated,
  unauthorized,
}

class AuthErrorClassifier {
  const AuthErrorClassifier._();

  static AuthErrorType? from({required int? code, required String message}) {
    final normalized = message.trim().toLowerCase();

    if (code == 9999 || normalized.contains('lỗi không xác định')) {
      return AuthErrorType.uncategorizedException;
    }

    if (normalized.contains('username đã tồn tại')) {
      return AuthErrorType.usernameExisted;
    }

    if (normalized.contains('email đã tồn tại')) {
      return AuthErrorType.emailExisted;
    }

    if (normalized.contains('số điện thoại đã tồn tại')) {
      return AuthErrorType.phoneExisted;
    }

    if (normalized.contains('không tìm thấy người dùng')) {
      return AuthErrorType.userNotFound;
    }

    if (normalized.contains('không tìm thấy quyền')) {
      return AuthErrorType.roleNotFound;
    }

    if (normalized.contains('username hoặc password không đúng')) {
      return AuthErrorType.invalidUsernameOrPassword;
    }

    if (normalized.contains('chưa xác thực')) {
      return AuthErrorType.unauthenticated;
    }

    if (normalized.contains('không có quyền truy cập')) {
      return AuthErrorType.unauthorized;
    }

    if (code == 400 || normalized.contains('dữ liệu không hợp lệ')) {
      return AuthErrorType.invalidRequest;
    }

    if (code == 401) {
      return AuthErrorType.unauthenticated;
    }

    if (code == 403) {
      return AuthErrorType.unauthorized;
    }

    return null;
  }
}
