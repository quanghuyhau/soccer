import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/auth_data_source.dart';
import 'package:soccer/data/data_source/services/booking_data_source.dart';
import 'package:soccer/data/data_source/services/pitch_data_source.dart';
import 'package:soccer/data/data_source/services/realtime_socket_data_source.dart';
import 'package:soccer/data/data_source/services/venue_data_source.dart';

export 'package:soccer/data/data_source/services/auth_data_source.dart';
export 'package:soccer/data/data_source/services/booking_data_source.dart';
export 'package:soccer/data/data_source/services/pitch_data_source.dart';
export 'package:soccer/data/data_source/services/realtime_socket_data_source.dart';
export 'package:soccer/data/data_source/services/venue_data_source.dart';

@lazySingleton
class AppDataSource {
  const AppDataSource({
    required this.auth,
    required this.venues,
    required this.pitches,
    required this.bookings,
    required this.realtime,
  });

  final AuthDataSource auth;
  final VenueDataSource venues;
  final PitchDataSource pitches;
  final BookingDataSource bookings;
  final RealtimeSocketDataSource realtime;
  void dispose() {
    realtime.dispose();
  }
}
