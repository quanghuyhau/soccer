import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'app_interceptor.dart';
import 'auth_token_provider.dart';
import 'curl_log_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final authToken = ref.watch(authTokenProvider);

  return Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {'Accept': 'application/json'},
      ),
    )
    ..interceptors.addAll([
      AppInterceptor(authToken),
      const CurlLogInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
});
