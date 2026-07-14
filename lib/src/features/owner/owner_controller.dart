import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../app/use_cases/app_use_case.dart';
import 'owner_state.dart';

final ownerDashboardControllerProvider =
    FutureProvider.autoDispose<OwnerDashboardData>((ref) async {
      final session = ref.watch(appSessionProvider);
      final user = session?.user;

      if (user == null) {
        return const OwnerDashboardData(venues: [], bookings: []);
      }

      final useCase = ref.watch(appUseCaseProvider);
      final results = await Future.wait<Object>([
        useCase.venues.getVenuesByOwner(user.id),
        useCase.bookings.getAllBookings(),
      ]);

      return OwnerDashboardData(
        venues: results[0] as List<Venue>,
        bookings: results[1] as List<Booking>,
      );
    });

final bookingStatusControllerProvider =
    StateNotifierProvider.autoDispose<
      BookingStatusController,
      AsyncValue<Booking?>
    >((ref) {
      return BookingStatusController(ref);
    });

final venueMutationControllerProvider =
    StateNotifierProvider.autoDispose<
      VenueMutationController,
      AsyncValue<Object?>
    >((ref) {
      return VenueMutationController(ref);
    });


class VenueMutationController extends StateNotifier<AsyncValue<Object?>> {
  VenueMutationController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> create(CreateVenueRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref.read(appUseCaseProvider).venues.createVenue(request);
    });

    _ref.invalidate(ownerDashboardControllerProvider);
  }

  Future<void> update({
    required String venueId,
    required CreateVenueRequest request,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref
          .read(appUseCaseProvider)
          .venues
          .updateVenue(UpdateVenueParams(venueId: venueId, request: request));
    });

    _ref.invalidate(ownerDashboardControllerProvider);
  }

  Future<void> delete(String venueId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(appUseCaseProvider).venues.deleteVenue(venueId);
      return true;
    });

    _ref.invalidate(ownerDashboardControllerProvider);
  }
}

class BookingStatusController extends StateNotifier<AsyncValue<Booking?>> {
  BookingStatusController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> update({
    required String bookingId,
    required String status,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref
          .read(appUseCaseProvider)
          .bookings
          .updateBookingStatus(
            UpdateBookingStatusParams(bookingId: bookingId, status: status),
          );
    });

    _ref.invalidate(ownerDashboardControllerProvider);
  }
}
