import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/venues/cubit/venue_detail_cubit.dart';
import 'package:soccer/presentation/screens/venues/state/pitch_action_state.dart';

class CreatePitchCubit extends Cubit<CreatePitchState> {
  CreatePitchCubit({
    required AppUseCase useCase,
    required VenueDetailCubit detailCubit,
  }) : _useCase = useCase,
       _detailCubit = detailCubit,
       super(const CreatePitchInitial());

  final AppUseCase _useCase;
  final VenueDetailCubit _detailCubit;

  Future<void> create({
    required String venueId,
    required CreatePitchRequest request,
    List<CreatePitchPriceRequest> prices = const [],
  }) async {
    emit(const CreatePitchLoading());
    try {
      final pitch = await _useCase.venues.createPitch(
        CreatePitchParams(venueId: venueId, request: request, prices: prices),
      );
      emit(CreatePitchSuccess(pitch));
      await _detailCubit.load();
    } catch (error, stackTrace) {
      emit(CreatePitchFailure.from(error, stackTrace));
    }
  }
}
