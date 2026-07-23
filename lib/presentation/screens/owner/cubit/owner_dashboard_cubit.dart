import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/presentation/screens/owner/state/owner_dashboard_state.dart';
import 'package:soccer/presentation/screens/owner/state/owner_state.dart';

@injectable
class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  OwnerDashboardCubit({
    required AppUseCase useCase,
    required AppSessionCubit sessionCubit,
  }) : _useCase = useCase,
       _sessionCubit = sessionCubit,
       super(const OwnerDashboardLoading()) {
    load();
  }

  final AppUseCase _useCase;
  final AppSessionCubit _sessionCubit;

  Future<void> load() async {
    emit(const OwnerDashboardLoading());
    try {
      final user = _sessionCubit.state?.user;
      if (user == null) {
        emit(
          const OwnerDashboardSuccess(
            OwnerDashboardData(venues: [], bookings: []),
          ),
        );
        return;
      }

      final results = await Future.wait<Object>([
        _useCase.venues.getVenuesByOwner(user.id),
        _useCase.bookings.getAllBookings(),
      ]);

      emit(
        OwnerDashboardSuccess(
          OwnerDashboardData(
            venues: results[0] as List<Venue>,
            bookings: results[1] as List<Booking>,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(OwnerDashboardFailure.from(error, stackTrace));
    }
  }
}
