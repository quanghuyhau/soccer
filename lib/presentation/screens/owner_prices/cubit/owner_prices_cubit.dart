import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/domain/use_cases/get_pitch_prices_usecase.dart';

part 'owner_prices_state.dart';

@injectable
class OwnerPricesCubit extends Cubit<OwnerPricesState> {
  final GetPitchPricesUseCase _getPitchPricesUseCase;

  OwnerPricesCubit({
    required GetPitchPricesUseCase getPitchPricesUseCase,
  })  : _getPitchPricesUseCase = getPitchPricesUseCase,
        super(OwnerPricesInitial());

  Future<void> fetchPrices(String pitchId) async {
    emit(OwnerPricesLoading());
    try {
      final response = await _getPitchPricesUseCase.getPrices(pitchId);
      if (response.success == true && response.result != null) {
        emit(OwnerPricesLoaded(response.result!));
      } else {
        emit(OwnerPricesError(response.message ?? 'Không thể tải cấu hình giá'));
      }
    } catch (e) {
      emit(OwnerPricesError('Lỗi kết nối: $e'));
    }
  }

  Future<void> addPrice(String pitchId, PitchPriceRequest request) async {
    final currentState = state;
    if (currentState is! OwnerPricesLoaded) return;

    try {
      final response = await _getPitchPricesUseCase.createPrice(pitchId, request);
      if (response.success == true) {
        // Refresh prices list
        final listResponse = await _getPitchPricesUseCase.getPrices(pitchId);
        if (listResponse.success == true && listResponse.result != null) {
          emit(OwnerPricesLoaded(listResponse.result!));
        }
      } else {
        emit(currentState.copyWith(
          errorMessage: response.message ?? 'Thêm khung giá thất bại',
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Lỗi kết nối: $e',
      ));
    }
  }

  Future<void> updatePrice(String pitchId, String priceId, PitchPriceRequest request) async {
    final currentState = state;
    if (currentState is! OwnerPricesLoaded) return;

    try {
      final response = await _getPitchPricesUseCase.updatePrice(priceId, request);
      if (response.success == true) {
        // Refresh prices list
        final listResponse = await _getPitchPricesUseCase.getPrices(pitchId);
        if (listResponse.success == true && listResponse.result != null) {
          emit(OwnerPricesLoaded(listResponse.result!));
        }
      } else {
        emit(currentState.copyWith(
          errorMessage: response.message ?? 'Cập nhật khung giá thất bại',
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Lỗi kết nối: $e',
      ));
    }
  }

  Future<void> removePrice(String pitchId, String priceId) async {
    final currentState = state;
    if (currentState is! OwnerPricesLoaded) return;

    try {
      final response = await _getPitchPricesUseCase.deletePrice(priceId);
      if (response.success == true) {
        // Refresh prices list
        final listResponse = await _getPitchPricesUseCase.getPrices(pitchId);
        if (listResponse.success == true && listResponse.result != null) {
          emit(OwnerPricesLoaded(listResponse.result!));
        }
      } else {
        emit(currentState.copyWith(
          errorMessage: response.message ?? 'Xóa khung giá thất bại',
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
    if (currentState is OwnerPricesLoaded) {
      emit(currentState.copyWith(errorMessage: null));
    }
  }
}
