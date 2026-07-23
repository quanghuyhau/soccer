import 'package:injectable/injectable.dart';

import 'package:soccer/domain/use_cases/login_use_case.dart';
import 'package:soccer/domain/use_cases/booking_use_case.dart';
import 'package:soccer/domain/use_cases/realtime_use_case.dart';
import 'package:soccer/domain/use_cases/venue_use_case.dart';

export 'package:soccer/domain/use_cases/login_use_case.dart';
export 'package:soccer/domain/use_cases/booking_use_case.dart';
export 'package:soccer/domain/use_cases/realtime_use_case.dart';
export 'package:soccer/domain/use_cases/venue_use_case.dart';

@lazySingleton
class AppUseCase {
  const AppUseCase({
    required this.auth,
    required this.venues,
    required this.bookings,
    required this.realtime,
  });

  final AuthUseCase auth;
  final VenueUseCase venues;
  final BookingUseCase bookings;
  final RealtimeUseCase realtime;
}
