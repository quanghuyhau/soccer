import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/response/booking_response.dart';
import 'package:soccer/domain/use_cases/booking_usecase.dart';

part 'my_bookings_state.dart';

@injectable
class MyBookingsCubit extends Cubit<MyBookingsState> {
  final BookingUseCase _bookingUseCase;

  MyBookingsCubit({
    required BookingUseCase bookingUseCase,
  })  : _bookingUseCase = bookingUseCase,
        super(MyBookingsInitial());

  Future<void> fetchMyBookings() async {
    emit(MyBookingsLoading());
    try {
      final response = await _bookingUseCase.getMyBookings();
      if (response.success == true && response.result != null) {
        emit(MyBookingsLoaded(response.result!));
      } else {
        emit(MyBookingsError(response.message ?? 'Không thể tải lịch sử đặt sân'));
      }
    } catch (e) {
      emit(MyBookingsError('Lỗi kết nối: $e'));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final currentState = state;
    if (currentState is! MyBookingsLoaded) return;

    try {
      final response = await _bookingUseCase.updateStatus(bookingId, 'CANCELLED');
      if (response.success == true) {
        // Refresh bookings list
        final listResponse = await _bookingUseCase.getMyBookings();
        if (listResponse.success == true && listResponse.result != null) {
          emit(MyBookingsLoaded(listResponse.result!));
        }
      } else {
        emit(currentState.copyWith(
          errorMessage: response.message ?? 'Hủy đặt sân thất bại',
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Lỗi kết nối: $e',
      ));
    }
  }

  void clearError() {
    final currentState = state;
    if (currentState is MyBookingsLoaded) {
      emit(currentState.copyWith(errorMessage: null));
    }
  }
}
