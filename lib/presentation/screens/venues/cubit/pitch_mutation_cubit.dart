import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/venues/cubit/venue_detail_cubit.dart';
import 'package:soccer/presentation/screens/venues/state/pitch_action_state.dart';

class PitchMutationCubit extends Cubit<PitchMutationState> {
  PitchMutationCubit({
    required AppUseCase useCase,
    required VenueDetailCubit detailCubit,
  }) : _useCase = useCase,
       _detailCubit = detailCubit,
       super(const PitchMutationInitial());

  final AppUseCase _useCase;
  final VenueDetailCubit _detailCubit;

  Future<void> update({
    required String venueId,
    required String pitchId,
    required CreatePitchRequest request,
  }) async {
    emit(const PitchMutationLoading());
    try {
      final pitch = await _useCase.venues.updatePitch(
        UpdatePitchParams(pitchId: pitchId, request: request),
      );
      emit(PitchMutationSuccess(pitch));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(PitchMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> delete({
    required String venueId,
    required String pitchId,
  }) async {
    emit(const PitchMutationLoading());
    try {
      await _useCase.venues.deletePitch(pitchId);
      emit(const PitchMutationSuccess(true));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(PitchMutationFailure.from(error, stackTrace));
    }
  }
}
