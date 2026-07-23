import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/presentation/common/app_state_listener.dart';
import 'package:soccer/presentation/common/widgets/app_button.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';
import 'package:soccer/presentation/screens/login/cubit/login_cubit.dart';
import 'package:soccer/presentation/screens/login/state/auth_state.dart';
import 'package:soccer/presentation/screens/login/ui/auth_layout.dart';
import 'package:soccer/presentation/screens/register/ui/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        AppStateListener.handleChange<void>(
          context,
          previous: null,
          current: state,
        );
      },
      builder: (context, authState) {
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
                    MaterialPageRoute<void>(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _login() {
    context.read<AuthCubit>().login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }
}
