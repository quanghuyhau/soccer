import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/venues/state/venue_detail_state.dart';

class VenueDetailCubit extends Cubit<VenueDetailState> {
  VenueDetailCubit({required AppUseCase useCase, required String venueId})
    : _useCase = useCase,
      _venueId = venueId,
      super(const VenueDetailLoading()) {
    load();
  }

  final AppUseCase _useCase;
  final String _venueId;

  Future<void> load() async {
    emit(const VenueDetailLoading());
    try {
      final detail = await _useCase.venues.getVenueDetail(_venueId);
      emit(VenueDetailSuccess(detail));
    } catch (error, stackTrace) {
      emit(VenueDetailFailure.from(error, stackTrace));
    }
  }
}
