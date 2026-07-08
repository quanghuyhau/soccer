import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import 'auth_data_source.dart';
import 'booking_data_source.dart';
import 'pitch_data_source.dart';
import 'venue_data_source.dart';

export 'auth_data_source.dart';
export 'booking_data_source.dart';
export 'pitch_data_source.dart';
export 'venue_data_source.dart';

final appDataSourceProvider = Provider<AppDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AppDataSource(
    auth: AuthDataSource(apiClient),
    venues: VenueDataSource(apiClient),
    pitches: PitchDataSource(apiClient),
    bookings: BookingDataSource(apiClient),
  );
});

class AppDataSource {
  const AppDataSource({
    required this.auth,
    required this.venues,
    required this.pitches,
    required this.bookings,
  });

  final AuthDataSource auth;
  final VenueDataSource venues;
  final PitchDataSource pitches;
  final BookingDataSource bookings;
}
