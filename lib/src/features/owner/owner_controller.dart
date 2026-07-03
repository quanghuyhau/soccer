import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../app/use_cases/app_use_case.dart';

final ownerDashboardControllerProvider =
    FutureProvider.autoDispose<OwnerDashboardData>((ref) async {
      final session = ref.watch(appSessionProvider);
      final user = session?.user;

      if (user == null) {
        return const OwnerDashboardData(venues: [], bookings: []);
      }

      final useCase = ref.watch(appUseCaseProvider);
      final results = await Future.wait<Object>([
        useCase.getVenuesByOwner(user.id),
        useCase.getAllBookings(),
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

class OwnerDashboardData {
  const OwnerDashboardData({required this.venues, required this.bookings});

  final List<Venue> venues;
  final List<Booking> bookings;
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
          .updateBookingStatus(
            UpdateBookingStatusParams(bookingId: bookingId, status: status),
          );
    });

    _ref.invalidate(ownerDashboardControllerProvider);
  }
}
