import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/venues/state/venues_state.dart';

@injectable
class VenuesCubit extends Cubit<VenuesState> {
  VenuesCubit(this._useCase) : super(const VenuesLoading()) {
    load();
  }

  final AppUseCase _useCase;

  Future<void> load() async {
    emit(const VenuesLoading());
    try {
      final venues = await _useCase.venues.getVenues();
      emit(VenuesSuccess(venues));
    } catch (error, stackTrace) {
      emit(VenuesFailure.from(error, stackTrace));
    }
  }
}
