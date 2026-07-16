import 'package:atm_soundbox/data/data_source/services/api_service.dart';
import 'package:atm_soundbox/di/environment/build_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:atm_soundbox/data/data_source/local/local_storage.dart';
import 'package:atm_soundbox/di/di.dart';
import 'package:atm_soundbox/utilities/constants/constants.dart';
import 'package:atm_soundbox/utilities/ultils/logging.dart';
import 'package:atm_soundbox/utilities/ultils/ultis.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @injectable
  Dio get dio {
    final Dio dio = Dio();
    dio.interceptors.add(analyticsCheckingInterceptor);
    dio.interceptors.add(dioLoggerInterceptor);

    return dio;
  }

  @injectable
  ApiService get adminService => ApiService(
        getIt<Dio>(),
        baseUrl: getIt<BuildConfig>().host,
      );
}

final analyticsCheckingInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] =
        'Bearer ${GetIt.instance.get<LocalStorage>().getAccessToken() ?? ''}';
    options.headers['Platform'] = Utils.platform;
    options.headers['Client-Id'] = uuid.v1();

    // options.headers[HttpHeaders.userAgentHeader] =
    //     '${Utils.packageInfo.appName}/${Utils.packageInfo.version} ($userAgent)';

    return handler.next(options); //continue
  },
  onResponse: (response, handler) {
    if (response.requestOptions.path == '/auth/login') {
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true) {
        if (response.headers.map.containsKey('access_token')) {
          final tokens = response.headers.map['access_token'] ?? [];
          if (tokens.isNotEmpty) {
            getIt.get<LocalStorage>().saveToken(tokens.first);
          }
        }
      }
    }

    return handler.next(response); // continue
  },
  onError: (DioException e, handler) {
    return handler.next(e); //continue
  },
);

final dioLoggerInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, handler) {
    String headers = '';
    options.headers.forEach((key, value) {
      headers += '| $key: $value';
    });

    Log.info(
      'dio',
      '┌------------------------------------------------------------------------------',
    );
    Log.info('dio', '''| [DIO] Request: ${options.method} ${options.uri}
| ${options.data.toString()}
| Headers:\n$headers''');
    Log.info(
      'dio',
      '├------------------------------------------------------------------------------',
    );
    handler.next(options); //continue
  },
  onResponse: (Response response, handler) async {
    Log.info(
      'dio',
      '| ${response.requestOptions.method} ${response.requestOptions.uri} [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}',
    );
    Log.info(
      'dio',
      '└------------------------------------------------------------------------------',
    );
    handler.next(response);
    // return response; // continue
  },
  onError: (DioException error, handler) async {
    Log.info(
      'dio',
      '| [DIO] Error: ${error.error}: ${error.response?.toString()}',
    );
    Log.info(
      'dio',
      '└------------------------------------------------------------------------------',
    );
    handler.next(error); //continue
  },
);
