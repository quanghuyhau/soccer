// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:soccer/data/data_source/local/local_storage.dart' as _i172;
import 'package:soccer/data/data_source/local/pref/shared_preferences_manager.dart'
    as _i435;
import 'package:soccer/data/data_source/services/api_service.dart' as _i95;
import 'package:soccer/data/repositories/booking_repo_impl.dart' as _i435;
import 'package:soccer/data/repositories/login_repo_impl.dart' as _i633;
import 'package:soccer/data/repositories/pitch_repo_impl.dart' as _i324;
import 'package:soccer/data/repositories/venue_repo_impl.dart' as _i991;
import 'package:soccer/di/environment/build_config.dart' as _i848;
import 'package:soccer/di/environment/build_config_prod.dart' as _i434;
import 'package:soccer/di/environment/build_config_uat.dart' as _i637;
import 'package:soccer/di/module/conponents_module.dart' as _i30;
import 'package:soccer/di/module/network_module.dart' as _i637;
import 'package:soccer/domain/repositories/booking_repository.dart' as _i378;
import 'package:soccer/domain/repositories/login_repository.dart' as _i506;
import 'package:soccer/domain/repositories/pitch_repository.dart' as _i350;
import 'package:soccer/domain/repositories/venue_repository.dart' as _i771;
import 'package:soccer/domain/use_cases/booking_usecase.dart' as _i683;
import 'package:soccer/domain/use_cases/get_pitch_prices_usecase.dart' as _i856;
import 'package:soccer/domain/use_cases/get_pitches_usecase.dart' as _i143;
import 'package:soccer/domain/use_cases/get_venues_usecase.dart' as _i697;
import 'package:soccer/domain/use_cases/login_usecase.dart' as _i1046;
import 'package:soccer/presentation/common/toast/toast_widget.dart' as _i898;
import 'package:soccer/presentation/screens/login/cubit/login_cubit.dart'
    as _i858;

const String _uat = 'uat';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final componentModule = _$ComponentModule();
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => componentModule.prefs,
      preResolve: true,
    );
    gh.factory<_i558.FlutterSecureStorage>(() => componentModule.secureStorage);
    gh.factory<_i361.Dio>(() => networkModule.dio);
    gh.factory<_i95.ApiService>(() => networkModule.adminService);
    gh.lazySingleton<_i898.ToastWidget>(() => _i898.ToastWidget());
    gh.singleton<_i435.SharedPreferencesManager>(
      () => _i435.SharedPreferencesManager(pref: gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i848.BuildConfig>(
      () => _i637.BuildConfigBeta(),
      registerFor: {_uat},
    );
    gh.factory<_i172.LocalStorage>(
      () => _i172.LocalStorage(
        preferences: gh<_i435.SharedPreferencesManager>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i506.LoginRepository>(
      () => _i633.LoginRepositoryImpl(
        apiService: gh<_i95.ApiService>(),
        localStorage: gh<_i172.LocalStorage>(),
      ),
    );
    gh.factory<_i378.BookingRepository>(
      () => _i435.BookingRepositoryImpl(apiService: gh<_i95.ApiService>()),
    );
    gh.factory<_i771.VenueRepository>(
      () => _i991.VenueRepositoryImpl(apiService: gh<_i95.ApiService>()),
    );
    gh.factory<_i1046.LoginUseCase>(
      () => _i1046.LoginUseCase(loginRepository: gh<_i506.LoginRepository>()),
    );
    gh.factory<_i350.PitchRepository>(
      () => _i324.PitchRepositoryImpl(apiService: gh<_i95.ApiService>()),
    );
    gh.factory<_i848.BuildConfig>(
      () => _i434.BuildConfigProd(),
      registerFor: {_prod},
    );
    gh.factory<_i856.GetPitchPricesUseCase>(
      () => _i856.GetPitchPricesUseCase(
        pitchRepository: gh<_i350.PitchRepository>(),
      ),
    );
    gh.factory<_i858.LoginCubit>(
      () => _i858.LoginCubit(loginUseCase: gh<_i1046.LoginUseCase>()),
    );
    gh.factory<_i683.BookingUseCase>(
      () => _i683.BookingUseCase(
        bookingRepository: gh<_i378.BookingRepository>(),
      ),
    );
    gh.factory<_i143.GetPitchesUseCase>(
      () =>
          _i143.GetPitchesUseCase(venueRepository: gh<_i771.VenueRepository>()),
    );
    gh.factory<_i697.GetVenuesUseCase>(
      () =>
          _i697.GetVenuesUseCase(venueRepository: gh<_i771.VenueRepository>()),
    );
    return this;
  }
}

class _$ComponentModule extends _i30.ComponentModule {}

class _$NetworkModule extends _i637.NetworkModule {}
