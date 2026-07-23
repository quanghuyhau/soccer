import 'package:dio/dio.dart';

import 'package:soccer/data/data_source/services/auth_token_provider.dart';
import 'package:soccer/data/data_source/services/app_endpoints.dart';
import 'package:soccer/data/data_source/services/token_refresh_service.dart';

const _skipAuthKey = 'skipAuth';
const _retriedAfterRefreshKey = 'retriedAfterRefresh';

class AppInterceptor extends Interceptor {
  AppInterceptor({
    required AuthTokenProvider authTokenProvider,
    required TokenRefreshService tokenRefreshService,
    required Dio dio,
  }) : _authTokenProvider = authTokenProvider,
       _tokenRefreshService = tokenRefreshService,
       _dio = dio;

  final AuthTokenProvider _authTokenProvider;
  final TokenRefreshService _tokenRefreshService;
  final Dio _dio;

  Future<String?>? _refreshingToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final shouldSkipAuth = options.extra[_skipAuthKey] == true;
    final token = shouldSkipAuth ? null : await _authTokenProvider.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldTryRefresh(err)) {
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessTokenOnce();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _authTokenProvider.clearSession();
        handler.next(err);
        return;
      }

      final retryOptions = _copyOptionsForRetry(err.requestOptions);
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      retryOptions.extra[_retriedAfterRefreshKey] = true;

      final response = await _dio.fetch<Object?>(retryOptions);
      handler.resolve(response);
    } catch (_) {
      await _authTokenProvider.clearSession();
      handler.next(err);
    }
  }

  bool _shouldTryRefresh(DioException err) {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    if (statusCode != 401) {
      return false;
    }

    if (options.extra[_skipAuthKey] == true ||
        options.extra[_retriedAfterRefreshKey] == true) {
      return false;
    }

    return options.path != AppEndpoints.authLogin &&
        options.path != AppEndpoints.authRegister &&
        options.path != AppEndpoints.authRefreshToken;
  }

  Future<String?> _refreshAccessTokenOnce() {
    final runningRefresh = _refreshingToken;
    if (runningRefresh != null) {
      return runningRefresh;
    }

    final refresh = _doRefreshAccessToken().whenComplete(() {
      _refreshingToken = null;
    });
    _refreshingToken = refresh;

    return refresh;
  }

  Future<String?> _doRefreshAccessToken() async {
    final refreshToken = await _authTokenProvider.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final tokens = await _tokenRefreshService.refresh(refreshToken);
    await _authTokenProvider.updateTokens(tokens);

    return tokens.accessToken;
  }

  RequestOptions _copyOptionsForRetry(RequestOptions options) {
    return RequestOptions(
      path: options.path,
      method: options.method,
      baseUrl: options.baseUrl,
      data: options.data,
      queryParameters: options.queryParameters,
      cancelToken: options.cancelToken,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      sendTimeout: options.sendTimeout,
      extra: Map<String, dynamic>.from(options.extra),
      headers: Map<String, dynamic>.from(options.headers),
      responseType: options.responseType,
      contentType: options.contentType,
      validateStatus: options.validateStatus,
      receiveDataWhenStatusError: options.receiveDataWhenStatusError,
      followRedirects: options.followRedirects,
      maxRedirects: options.maxRedirects,
      requestEncoder: options.requestEncoder,
      responseDecoder: options.responseDecoder,
      listFormat: options.listFormat,
    );
  }
}
