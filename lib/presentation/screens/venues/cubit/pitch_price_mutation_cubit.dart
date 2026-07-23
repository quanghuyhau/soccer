import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/venues/cubit/venue_detail_cubit.dart';
import 'package:soccer/presentation/screens/venues/state/pitch_action_state.dart';

class PitchPriceMutationCubit extends Cubit<PitchPriceMutationState> {
  PitchPriceMutationCubit({
    required AppUseCase useCase,
    required VenueDetailCubit detailCubit,
  }) : _useCase = useCase,
       _detailCubit = detailCubit,
       super(const PitchPriceMutationInitial());

  final AppUseCase _useCase;
  final VenueDetailCubit _detailCubit;

  Future<void> create({
    required String venueId,
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) async {
    emit(const PitchPriceMutationLoading());
    try {
      final price = await _useCase.venues.createPitchPrice(
        CreatePitchPriceParams(pitchId: pitchId, request: request),
      );
      emit(PitchPriceMutationSuccess(price));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(PitchPriceMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> update({
    required String venueId,
    required String priceId,
    required CreatePitchPriceRequest request,
  }) async {
    emit(const PitchPriceMutationLoading());
    try {
      final price = await _useCase.venues.updatePitchPrice(
        UpdatePitchPriceParams(priceId: priceId, request: request),
      );
      emit(PitchPriceMutationSuccess(price));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(PitchPriceMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> delete({
    required String venueId,
    required String priceId,
  }) async {
    emit(const PitchPriceMutationLoading());
    try {
      await _useCase.venues.deletePitchPrice(priceId);
      emit(const PitchPriceMutationSuccess(true));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(PitchPriceMutationFailure.from(error, stackTrace));
    }
  }
}
