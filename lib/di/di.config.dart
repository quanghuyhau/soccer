// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:atm_soundbox/data/data_source/local/local_storage.dart'
    as _i323;
import 'package:atm_soundbox/data/data_source/local/pref/shared_preferences_manager.dart'
    as _i469;
import 'package:atm_soundbox/data/data_source/services/api_service.dart'
    as _i409;
import 'package:atm_soundbox/data/repositories/login_repo_impl.dart' as _i458;
import 'package:atm_soundbox/di/environment/build_config.dart' as _i103;
import 'package:atm_soundbox/di/environment/build_config_prod.dart' as _i562;
import 'package:atm_soundbox/di/environment/build_config_uat.dart' as _i720;
import 'package:atm_soundbox/di/module/conponents_module.dart' as _i5;
import 'package:atm_soundbox/di/module/network_module.dart' as _i989;
import 'package:atm_soundbox/domain/repositories/login_repository.dart'
    as _i302;
import 'package:atm_soundbox/domain/use_cases/login_usecase.dart' as _i782;
import 'package:atm_soundbox/presentation/common/toast/toast_widget.dart'
    as _i125;
import 'package:atm_soundbox/presentation/screens/login/cubit/login_cubit.dart'
    as _i142;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _uat = 'uat';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final componentModule = _$ComponentModule();
    gh.factory<_i361.Dio>(() => networkModule.dio);
    gh.factory<_i409.ApiService>(() => networkModule.adminService);
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => componentModule.prefs,
      preResolve: true,
    );
    gh.factory<_i558.FlutterSecureStorage>(() => componentModule.secureStorage);
    gh.lazySingleton<_i125.ToastWidget>(() => _i125.ToastWidget());
    gh.singleton<_i469.SharedPreferencesManager>(() =>
        _i469.SharedPreferencesManager(pref: gh<_i460.SharedPreferences>()));
    gh.factory<_i103.BuildConfig>(
      () => _i720.BuildConfigBeta(),
      registerFor: {_uat},
    );
    gh.factory<_i103.BuildConfig>(
      () => _i562.BuildConfigProd(),
      registerFor: {_prod},
    );
    gh.factory<_i323.LocalStorage>(() => _i323.LocalStorage(
          preferences: gh<_i469.SharedPreferencesManager>(),
          secureStorage: gh<_i558.FlutterSecureStorage>(),
        ));
    gh.factory<_i302.LoginRepository>(() => _i458.LoginRepositoryImpl(
          apiService: gh<_i409.ApiService>(),
          localStorage: gh<_i323.LocalStorage>(),
        ));
    gh.factory<_i782.LoginUseCase>(
        () => _i782.LoginUseCase(loginRepository: gh<_i302.LoginRepository>()));
    gh.factory<_i142.LoginCubit>(
        () => _i142.LoginCubit(loginUseCase: gh<_i782.LoginUseCase>()));
    return this;
  }
}

class _$NetworkModule extends _i989.NetworkModule {}

class _$ComponentModule extends _i5.ComponentModule {}
