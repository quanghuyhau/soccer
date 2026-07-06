import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công')));
            Navigator.of(context).pop();
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
        },
      );
    });

    return AuthScaffold(
      title: 'Tạo tài khoản',
      subtitle: 'Tạo hồ sơ để bắt đầu đặt sân',
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
          const SizedBox(height: 12),
          AppTextField(
            controller: _fullNameController,
            label: 'Họ tên',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _addressController,
            label: 'Địa chỉ',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          AppButton.primary(
            label: 'Tạo tài khoản',
            icon: const Icon(Icons.person_add),
            isLoading: authState.isLoading,
            isExpanded: true,
            onPressed: _register,
          ),
          const SizedBox(height: 12),
          AppButton.text(
            label: 'Quay lại đăng nhập',
            icon: const Icon(Icons.arrow_back),
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _register() {
    ref
        .read(authControllerProvider.notifier)
        .register(
          username: _usernameController.text,
          password: _passwordController.text,
          fullName: _fullNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        );
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Đăng ký không thành công';
  }
}
