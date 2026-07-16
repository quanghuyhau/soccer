import 'package:injectable/injectable.dart';
import 'package:soccer/di/environment/build_config.dart';

@Injectable(as: BuildConfig, env: [CustomEnv.prod])
class BuildConfigProd extends BuildConfig {
  @override
  String get host => '';
}
