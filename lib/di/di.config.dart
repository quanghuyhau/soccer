// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:soccer/data/data_source/services/api_client.dart' as _i373;
import 'package:soccer/data/data_source/services/app_data_source.dart' as _i149;
import 'package:soccer/data/data_source/services/auth_data_source.dart'
    as _i370;
import 'package:soccer/data/data_source/services/auth_token_provider.dart'
    as _i896;
import 'package:soccer/data/data_source/services/booking_data_source.dart'
    as _i105;
import 'package:soccer/data/data_source/services/pitch_data_source.dart'
    as _i533;
import 'package:soccer/data/data_source/services/realtime_socket_data_source.dart'
    as _i1034;
import 'package:soccer/data/data_source/services/token_refresh_service.dart'
    as _i585;
import 'package:soccer/data/data_source/services/venue_data_source.dart'
    as _i1034;
import 'package:soccer/data/repositories/booking_repository_impl.dart' as _i612;
import 'package:soccer/data/repositories/login_repo_impl.dart' as _i633;
import 'package:soccer/data/repositories/pitch_repository_impl.dart' as _i991;
import 'package:soccer/data/repositories/realtime_repository_impl.dart'
    as _i976;
import 'package:soccer/data/repositories/venue_repository_impl.dart' as _i725;
import 'package:soccer/di/di.dart' as _i524;
import 'package:soccer/di/environment/app_config.dart' as _i529;
import 'package:soccer/domain/repositories/app_repository.dart' as _i1009;
import 'package:soccer/domain/repositories/booking_repository.dart' as _i378;
import 'package:soccer/domain/repositories/login_repository.dart' as _i506;
import 'package:soccer/domain/repositories/pitch_repository.dart' as _i350;
import 'package:soccer/domain/repositories/realtime_repository.dart' as _i602;
import 'package:soccer/domain/repositories/venue_repository.dart' as _i771;
import 'package:soccer/domain/use_cases/app_use_case.dart' as _i761;
import 'package:soccer/domain/use_cases/booking_use_case.dart' as _i70;
import 'package:soccer/domain/use_cases/login_use_case.dart' as _i687;
import 'package:soccer/domain/use_cases/realtime_use_case.dart' as _i393;
import 'package:soccer/domain/use_cases/venue_use_case.dart' as _i119;
import 'package:soccer/presentation/application/app_session.dart' as _i137;
import 'package:soccer/presentation/screens/bookings/cubit/my_bookings_cubit.dart'
    as _i934;
import 'package:soccer/presentation/screens/login/cubit/login_cubit.dart'
    as _i858;
import 'package:soccer/presentation/screens/owner/cubit/owner_dashboard_cubit.dart'
    as _i463;
import 'package:soccer/presentation/screens/venues/cubit/venues_cubit.dart'
    as _i744;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appInjectableModule = _$AppInjectableModule();
    gh.lazySingleton<_i1034.RealtimeSocketDataSource>(
      () => _i1034.RealtimeSocketDataSource(),
    );
    gh.lazySingleton<_i529.AppConfig>(() => appInjectableModule.appConfig);
    gh.lazySingleton<_i137.AppSessionCubit>(() => _i137.AppSessionCubit());
    gh.lazySingleton<_i896.AuthTokenProvider>(
      () => appInjectableModule.authTokenProvider(gh<_i137.AppSessionCubit>()),
    );
    gh.lazySingleton<_i602.RealtimeRepository>(
      () => _i976.RealtimeRepositoryImpl(gh<_i149.RealtimeSocketDataSource>()),
    );
    gh.lazySingleton<_i585.TokenRefreshService>(
      () => _i585.TokenRefreshService(gh<_i529.AppConfig>()),
    );
    gh.lazySingleton<_i393.RealtimeUseCase>(
      () => _i393.RealtimeUseCase(gh<_i602.RealtimeRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => appInjectableModule.dio(
        gh<_i529.AppConfig>(),
        gh<_i896.AuthTokenProvider>(),
        gh<_i585.TokenRefreshService>(),
      ),
    );
    gh.lazySingleton<_i373.ApiClient>(() => _i373.ApiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i370.AuthDataSource>(
      () => _i370.AuthDataSource(gh<_i373.ApiClient>()),
    );
    gh.lazySingleton<_i105.BookingDataSource>(
      () => _i105.BookingDataSource(gh<_i373.ApiClient>()),
    );
    gh.lazySingleton<_i533.PitchDataSource>(
      () => _i533.PitchDataSource(gh<_i373.ApiClient>()),
    );
    gh.lazySingleton<_i1034.VenueDataSource>(
      () => _i1034.VenueDataSource(gh<_i373.ApiClient>()),
    );
    gh.lazySingleton<_i771.VenueRepository>(
      () => _i725.VenueRepositoryImpl(gh<_i149.VenueDataSource>()),
    );
    gh.lazySingleton<_i378.BookingRepository>(
      () => _i612.BookingRepositoryImpl(gh<_i149.BookingDataSource>()),
    );
    gh.lazySingleton<_i350.PitchRepository>(
      () => _i991.PitchRepositoryImpl(gh<_i149.PitchDataSource>()),
    );
    gh.lazySingleton<_i119.VenueUseCase>(
      () => _i119.VenueUseCase(
        venueRepository: gh<_i771.VenueRepository>(),
        pitchRepository: gh<_i350.PitchRepository>(),
      ),
    );
    gh.lazySingleton<_i506.AuthRepository>(
      () => _i633.AuthRepositoryImpl(gh<_i149.AuthDataSource>()),
    );
    gh.lazySingleton<_i149.AppDataSource>(
      () => _i149.AppDataSource(
        auth: gh<_i149.AuthDataSource>(),
        venues: gh<_i149.VenueDataSource>(),
        pitches: gh<_i149.PitchDataSource>(),
        bookings: gh<_i149.BookingDataSource>(),
        realtime: gh<_i149.RealtimeSocketDataSource>(),
      ),
    );
    gh.lazySingleton<_i687.AuthUseCase>(
      () => _i687.AuthUseCase(gh<_i506.AuthRepository>()),
    );
    gh.lazySingleton<_i70.BookingUseCase>(
      () => _i70.BookingUseCase(gh<_i378.BookingRepository>()),
    );
    gh.lazySingleton<_i761.AppUseCase>(
      () => _i761.AppUseCase(
        auth: gh<_i761.AuthUseCase>(),
        venues: gh<_i761.VenueUseCase>(),
        bookings: gh<_i761.BookingUseCase>(),
        realtime: gh<_i761.RealtimeUseCase>(),
      ),
    );
    gh.lazySingleton<_i1009.AppRepository>(
      () => _i1009.AppRepository(
        auth: gh<_i1009.AuthRepository>(),
        venues: gh<_i1009.VenueRepository>(),
        pitches: gh<_i1009.PitchRepository>(),
        bookings: gh<_i1009.BookingRepository>(),
        realtime: gh<_i1009.RealtimeRepository>(),
      ),
    );
    gh.factory<_i934.MyBookingsCubit>(
      () => _i934.MyBookingsCubit(gh<_i761.AppUseCase>()),
    );
    gh.factory<_i744.VenuesCubit>(
      () => _i744.VenuesCubit(gh<_i761.AppUseCase>()),
    );
    gh.factory<_i858.AuthCubit>(
      () => _i858.AuthCubit(
        useCase: gh<_i761.AppUseCase>(),
        sessionCubit: gh<_i137.AppSessionCubit>(),
      ),
    );
    gh.factory<_i463.OwnerDashboardCubit>(
      () => _i463.OwnerDashboardCubit(
        useCase: gh<_i761.AppUseCase>(),
        sessionCubit: gh<_i137.AppSessionCubit>(),
      ),
    );
    return this;
  }
}

class _$AppInjectableModule extends _i524.AppInjectableModule {}
