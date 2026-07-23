import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/auth_token_provider.dart';
import 'package:soccer/data/data_source/services/dio_provider.dart';
import 'package:soccer/data/data_source/services/token_refresh_service.dart';
import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/presentation/application/app_session.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: false,
  asExtension: true,
)
void configureDependencies() => getIt.init();

@module
abstract class AppInjectableModule {
  @lazySingleton
  AppConfig get appConfig => AppConfig.fromEnvironment();

  @lazySingleton
  AuthTokenProvider authTokenProvider(AppSessionCubit sessionCubit) {
    return AuthTokenProvider(
      readAccessToken: () async => sessionCubit.state?.tokens.accessToken,
      readRefreshToken: () async => sessionCubit.state?.tokens.refreshToken,
      updateTokens: (tokens) async => sessionCubit.updateTokens(tokens),
      clearSession: () async => sessionCubit.clear(),
    );
  }

  @lazySingleton
  Dio dio(
    AppConfig config,
    AuthTokenProvider authTokenProvider,
    TokenRefreshService tokenRefreshService,
  ) {
    return createAppDio(
      config: config,
      authTokenProvider: authTokenProvider,
      tokenRefreshService: tokenRefreshService,
    );
  }
}
