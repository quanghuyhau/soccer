import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/presentation/screens/shell/ui/main_shell.dart';
import 'package:soccer/presentation/screens/login/ui/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSessionCubit, AuthSessionData?>(
      builder: (context, session) {
        if (session == null) {
          return const LoginScreen();
        }

        return const MainShell();
      },
    );
  }
}
