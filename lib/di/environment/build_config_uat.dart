import 'package:injectable/injectable.dart';
import 'package:soccer/di/environment/build_config.dart';

@Injectable(as: BuildConfig, env: [CustomEnv.uat])
class BuildConfigBeta extends BuildConfig {
  @override
  String get host => '';
}
