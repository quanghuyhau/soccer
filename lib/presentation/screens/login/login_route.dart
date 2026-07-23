import 'package:flutter/material.dart';

import 'ui/login_screen.dart';

class LoginRoute {
  const LoginRoute._();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
  }
}
