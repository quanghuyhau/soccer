import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/owner/cubit/owner_dashboard_cubit.dart';
import 'package:soccer/presentation/screens/owner/state/booking_status_state.dart';

class BookingStatusCubit extends Cubit<BookingStatusState> {
  BookingStatusCubit({
    required AppUseCase useCase,
    required OwnerDashboardCubit dashboardCubit,
  }) : _useCase = useCase,
       _dashboardCubit = dashboardCubit,
       super(const BookingStatusInitial());

  final AppUseCase _useCase;
  final OwnerDashboardCubit _dashboardCubit;

  Future<void> update({
    required String bookingId,
    required String status,
  }) async {
    emit(const BookingStatusLoading());
    try {
      final booking = await _useCase.bookings.updateBookingStatus(
        UpdateBookingStatusParams(bookingId: bookingId, status: status),
      );
      emit(BookingStatusSuccess(booking));
      await _dashboardCubit.load();
    } catch (error, stackTrace) {
      emit(BookingStatusFailure.from(error, stackTrace));
    }
  }
}
