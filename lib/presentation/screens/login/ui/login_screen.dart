import 'package:atm_soundbox/presentation/common/app_scaffold_widget.dart';
import 'package:atm_soundbox/presentation/screens/login/cubit/login_cubit.dart';
import 'package:atm_soundbox/utilities/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return BlocListener<LoginCubit, LoginState>(
      listener: _handleListener,
      child: AppScaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _loginForm(),
        ),
      ),
    );
  }

  _loginForm() {
    return Container();
  }

  _handleListener(BuildContext context, LoginState state) {
    // handle event fired
  }
}
