import 'package:injectable/injectable.dart';

abstract class CustomEnv {
  static const String uat = 'uat';
  static const String prod = 'prod';
}

const uat = Environment(CustomEnv.uat);
const prod = Environment(CustomEnv.prod);

abstract class BuildConfig {
  String get host;
}
