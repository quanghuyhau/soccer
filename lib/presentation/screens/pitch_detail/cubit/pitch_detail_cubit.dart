import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/booking_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/domain/use_cases/booking_usecase.dart';
import 'package:soccer/domain/use_cases/get_pitch_prices_usecase.dart';

part 'pitch_detail_state.dart';

@injectable
class PitchDetailCubit extends Cubit<PitchDetailState> {
  final GetPitchPricesUseCase _getPitchPricesUseCase;
  final BookingUseCase _bookingUseCase;

  PitchDetailCubit({
    required GetPitchPricesUseCase getPitchPricesUseCase,
    required BookingUseCase bookingUseCase,
  })  : _getPitchPricesUseCase = getPitchPricesUseCase,
        _bookingUseCase = bookingUseCase,
        super(PitchDetailInitial());

  Future<void> loadPitchPrices(String pitchId) async {
    emit(PitchDetailLoading());
    try {
      final response = await _getPitchPricesUseCase.getPrices(pitchId);
      if (response.success == true && response.result != null) {
        emit(PitchDetailLoaded(prices: response.result!));
      } else {
        emit(PitchDetailError(response.message ?? 'Không thể tải bảng giá sân'));
      }
    } catch (e) {
      emit(PitchDetailError('Lỗi kết nối: $e'));
    }
  }

  Future<void> submitBooking(BookingRequest request) async {
    final currentState = state;
    if (currentState is! PitchDetailLoaded) return;

    emit(PitchDetailLoading());
    try {
      final response = await _bookingUseCase.create(request);
      if (response.success == true && response.result != null) {
        emit(currentState.copyWith(
          latestBooking: response.result,
          errorMessage: null,
        ));
      } else {
        emit(currentState.copyWith(
          errorMessage: response.message ?? 'Đặt sân thất bại',
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Lỗi kết nối: $e',
      ));
    }
  }

  void clearBookingResult() {
    final currentState = state;
    if (currentState is PitchDetailLoaded) {
      emit(currentState.copyWith(latestBooking: null, errorMessage: null));
    }
  }
}
