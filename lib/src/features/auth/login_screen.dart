import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'owner');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
        },
      );
    });

    return AuthScaffold(
      title: 'Đăng nhập',
      subtitle: 'Vào hệ thống để quản lý sân và lịch đặt',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _usernameController,
            label: 'Tên đăng nhập',
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passwordController,
            label: 'Mật khẩu',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: null,
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          const SizedBox(height: 6),
          AppButton.primary(
            label: 'Đăng nhập',
            icon: const Icon(Icons.login),
            isLoading: authState.isLoading,
            isExpanded: true,
            onPressed: _login,
          ),
          const SizedBox(height: 12),
          AppButton.text(
            label: 'Tạo tài khoản mới',
            icon: const Icon(Icons.person_add_alt_1),
            isExpanded: true,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _login() {
    ref
        .read(authControllerProvider.notifier)
        .login(
          username: _usernameController.text,
          password: _passwordController.text,
        );
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Đăng nhập không thành công';
  }
}
