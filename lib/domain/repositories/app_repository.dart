import 'package:injectable/injectable.dart';

import 'package:soccer/domain/repositories/login_repository.dart';
import 'package:soccer/domain/repositories/booking_repository.dart';
import 'package:soccer/domain/repositories/pitch_repository.dart';
import 'package:soccer/domain/repositories/realtime_repository.dart';
import 'package:soccer/domain/repositories/venue_repository.dart';

export 'package:soccer/domain/repositories/login_repository.dart';
export 'package:soccer/domain/repositories/booking_repository.dart';
export 'package:soccer/domain/repositories/pitch_repository.dart';
export 'package:soccer/domain/repositories/realtime_repository.dart';
export 'package:soccer/domain/repositories/venue_repository.dart';

@lazySingleton
class AppRepository {
  const AppRepository({
    required this.auth,
    required this.venues,
    required this.pitches,
    required this.bookings,
    required this.realtime,
  });

  final AuthRepository auth;
  final VenueRepository venues;
  final PitchRepository pitches;
  final BookingRepository bookings;
  final RealtimeRepository realtime;
}
