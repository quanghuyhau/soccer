import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/app_repository.dart';
import 'auth_use_case.dart';
import 'booking_use_case.dart';
import 'venue_use_case.dart';

export 'auth_use_case.dart';
export 'booking_use_case.dart';
export 'venue_use_case.dart';

final appUseCaseProvider = Provider<AppUseCase>((ref) {
  final repository = ref.watch(appRepositoryProvider);

  return AppUseCase(
    auth: AuthUseCase(repository.auth),
    venues: VenueUseCase(
      venueRepository: repository.venues,
      pitchRepository: repository.pitches,
    ),
    bookings: BookingUseCase(repository.bookings),
  );
});

class AppUseCase {
  const AppUseCase({
    required this.auth,
    required this.venues,
    required this.bookings,
  });

  final AuthUseCase auth;
  final VenueUseCase venues;
  final BookingUseCase bookings;
}
