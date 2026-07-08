import 'package:dio/dio.dart';

import 'auth_token_provider.dart';

class AppInterceptor extends Interceptor {
  const AppInterceptor(this._authTokenProvider);

  final AuthTokenProvider _authTokenProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authTokenProvider.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    handler.next(options);
  }
}
