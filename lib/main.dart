import 'package:soccer/helpers/fcm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/di/environment/build_config.dart';
import 'package:soccer/presentation/application/application.dart';
import 'package:soccer/utilities/ultils/logging.dart';
import 'package:soccer/utilities/ultils/ultis.dart';

const env =
    String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: CustomEnv.uat);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Log.setLevel(env: env);

  await Utils.initSystemInfo();

  // Init FCM
  await FCMService.I.initialize();
  FCMService.I.getInitialFCMMessage();
  Log.info('FCM Token: ', await FCMService.I.getToken() ?? '');

  await configureDependencies(env: env);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterNativeSplash.remove();

  runApp(const Application());
}
