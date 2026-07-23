import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/data/data_source/services/app_data_source.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/utilities/routes/app_navigator.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';
import 'package:soccer/presentation/screens/login/cubit/login_cubit.dart';
import 'package:soccer/presentation/application/auth_gate.dart';
import 'package:soccer/presentation/application/app_session.dart';

class SoccerApp extends StatefulWidget {
  const SoccerApp({super.key});

  @override
  State<SoccerApp> createState() => _SoccerAppState();
}

class _SoccerAppState extends State<SoccerApp> {
  @override
  void initState() {
    super.initState();
    if (!getIt.isRegistered<AppUseCase>()) {
      configureDependencies();
    }
  }

  @override
  void dispose() {
    getIt<AppDataSource>().dispose();
    getIt<AppSessionCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getIt<AppConfig>()),
        RepositoryProvider.value(value: getIt<AppUseCase>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSessionCubit>.value(value: getIt<AppSessionCubit>()),
          BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        ],
        child: MaterialApp(
          navigatorKey: appNavigatorKey,
          title: 'Soccer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.teal,
              primary: AppColors.teal,
              secondary: AppColors.coral,
              tertiary: AppColors.amber,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.canvas,
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.canvas,
              foregroundColor: AppColors.ink,
            ),
            cardTheme: const CardThemeData(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: AppColors.line),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFFDCE4DE)),
              ),
            ),
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: AppColors.mint,
            ),
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}
