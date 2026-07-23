import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/owner/cubit/owner_dashboard_cubit.dart';
import 'package:soccer/presentation/screens/owner/state/venue_mutation_state.dart';
import 'package:soccer/presentation/screens/venues/cubit/venues_cubit.dart';

class VenueMutationCubit extends Cubit<VenueMutationState> {
  VenueMutationCubit({
    required AppUseCase useCase,
    OwnerDashboardCubit? dashboardCubit,
    VenuesCubit? venuesCubit,
  }) : _useCase = useCase,
       _dashboardCubit = dashboardCubit,
       _venuesCubit = venuesCubit,
       super(const VenueMutationInitial());

  final AppUseCase _useCase;
  final OwnerDashboardCubit? _dashboardCubit;
  final VenuesCubit? _venuesCubit;

  Future<void> create(CreateVenueRequest request) async {
    emit(const VenueMutationLoading());
    try {
      final venue = await _useCase.venues.createVenue(request);
      emit(VenueMutationSuccess(venue));
      await _reload();
    } catch (error, stackTrace) {
      emit(VenueMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> update({
    required String venueId,
    required CreateVenueRequest request,
  }) async {
    emit(const VenueMutationLoading());
    try {
      final venue = await _useCase.venues.updateVenue(
        UpdateVenueParams(venueId: venueId, request: request),
      );
      emit(VenueMutationSuccess(venue));
      await _reload();
    } catch (error, stackTrace) {
      emit(VenueMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> delete(String venueId) async {
    emit(const VenueMutationLoading());
    try {
      await _useCase.venues.deleteVenue(venueId);
      emit(const VenueMutationSuccess(true));
      await _reload();
    } catch (error, stackTrace) {
      emit(VenueMutationFailure.from(error, stackTrace));
    }
  }

  Future<void> _reload() async {
    await _dashboardCubit?.load();
    await _venuesCubit?.load();
  }
}
