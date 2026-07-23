import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';

import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/data/data_source/services/app_dio_logger.dart';
import 'package:soccer/data/data_source/services/app_interceptor.dart';
import 'package:soccer/data/data_source/services/auth_token_provider.dart';
import 'package:soccer/data/data_source/services/token_refresh_service.dart';

Dio createAppDio({
  required AppConfig config,
  required AuthTokenProvider authTokenProvider,
  required TokenRefreshService tokenRefreshService,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AppInterceptor(
      authTokenProvider: authTokenProvider,
      tokenRefreshService: tokenRefreshService,
      dio: dio,
    ),
    AppDioLogger(),
    CurlLoggerDioInterceptor(printOnSuccess: true),
  ]);

  return dio;
}
