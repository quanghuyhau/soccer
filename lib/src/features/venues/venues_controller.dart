import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/use_cases/app_use_case.dart';

final venuesControllerProvider = FutureProvider.autoDispose<List<Venue>>((ref) {
  return ref.watch(appUseCaseProvider).getVenues();
});

final venueDetailControllerProvider = FutureProvider.autoDispose
    .family<VenueDetailData, String>((ref, venueId) {
      return ref.watch(appUseCaseProvider).getVenueDetail(venueId);
    });
