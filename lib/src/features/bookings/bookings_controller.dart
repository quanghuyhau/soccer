import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../app/models/app_models.dart';
import '../../app/use_cases/app_use_case.dart';

final myBookingsControllerProvider = FutureProvider.autoDispose<List<Booking>>((
  ref,
) {
  return ref.watch(appUseCaseProvider).bookings.getMyBookings();
});

final createBookingControllerProvider =
    StateNotifierProvider.autoDispose<
      CreateBookingController,
      AsyncValue<Booking?>
    >((ref) {
      return CreateBookingController(ref);
    });

class CreateBookingController extends StateNotifier<AsyncValue<Booking?>> {
  CreateBookingController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> create(CreateBookingRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _ref.read(appUseCaseProvider).bookings.createBooking(request);
    });

    _ref.invalidate(myBookingsControllerProvider);
  }
}
