import 'package:atm_soundbox/di/environment/build_config.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BuildConfig, env: [CustomEnv.uat])
class BuildConfigBeta extends BuildConfig {
  @override
  String get host => '';
}
