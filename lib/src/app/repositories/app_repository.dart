import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_sources/app_data_source.dart';
import 'auth_repository.dart';
import 'booking_repository.dart';
import 'impl/auth_repository_impl.dart';
import 'impl/booking_repository_impl.dart';
import 'impl/pitch_repository_impl.dart';
import 'impl/venue_repository_impl.dart';
import 'pitch_repository.dart';
import 'venue_repository.dart';

export 'auth_repository.dart';
export 'booking_repository.dart';
export 'pitch_repository.dart';
export 'venue_repository.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) {
  final dataSource = ref.watch(appDataSourceProvider);

  return AppRepository(
    auth: AuthRepositoryImpl(dataSource.auth),
    venues: VenueRepositoryImpl(dataSource.venues),
    pitches: PitchRepositoryImpl(dataSource.pitches),
    bookings: BookingRepositoryImpl(dataSource.bookings),
  );
});

class AppRepository {
  const AppRepository({
    required this.auth,
    required this.venues,
    required this.pitches,
    required this.bookings,
  });

  final AuthRepository auth;
  final VenueRepository venues;
  final PitchRepository pitches;
  final BookingRepository bookings;
}
