import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/use_cases/app_use_case.dart';

final venuesControllerProvider = FutureProvider.autoDispose<List<Venue>>((ref) {
  return ref.watch(appUseCaseProvider).getVenues();
});

final venueDetailControllerProvider = FutureProvider.autoDispose
    .family<VenueDetailData, String>((ref, venueId) {
      return ref.watch(appUseCaseProvider).getVenueDetail(venueId);
    });

final createPitchPriceControllerProvider =
    StateNotifierProvider.autoDispose<
      CreatePitchPriceController,
      AsyncValue<PitchPrice?>
    >((ref) {
      return CreatePitchPriceController(ref);
    });

final createPitchControllerProvider =
    StateNotifierProvider.autoDispose<
      CreatePitchController,
      AsyncValue<Pitch?>
    >((ref) {
      return CreatePitchController(ref);
    });

class CreatePitchController extends StateNotifier<AsyncValue<Pitch?>> {
  CreatePitchController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> create({
    required String venueId,
    required CreatePitchRequest request,
    List<CreatePitchPriceRequest> prices = const [],
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref
          .read(appUseCaseProvider)
          .createPitch(
            CreatePitchParams(
              venueId: venueId,
              request: request,
              prices: prices,
            ),
          );
    });

    _ref.invalidate(venueDetailControllerProvider(venueId));
  }
}

class CreatePitchPriceController
    extends StateNotifier<AsyncValue<PitchPrice?>> {
  CreatePitchPriceController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> create({
    required String venueId,
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref
          .read(appUseCaseProvider)
          .createPitchPrice(
            CreatePitchPriceParams(pitchId: pitchId, request: request),
          );
    });

    _ref.invalidate(venueDetailControllerProvider(venueId));
  }
}
