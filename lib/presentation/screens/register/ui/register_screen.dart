import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/presentation/common/app_state_listener.dart';
import 'package:soccer/presentation/common/widgets/app_button.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';
import 'package:soccer/presentation/common/widgets/app_feedback.dart';
import 'package:soccer/presentation/screens/login/cubit/login_cubit.dart';
import 'package:soccer/presentation/screens/login/state/auth_state.dart';
import 'package:soccer/presentation/screens/login/ui/auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        AppStateListener.handleChange<void>(
          context,
          previous: null,
          current: state,
          onSuccess: (_) {
            if (state is! RegisterSuccess) {
              return;
            }
            AppToast.success(context, 'Đăng ký thành công');
            Navigator.of(context).pop();
          },
        );
      },
      builder: (context, authState) {
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
      },
    );
  }

  void _register() {
    context.read<AuthCubit>().register(
      username: _usernameController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
  }
}
