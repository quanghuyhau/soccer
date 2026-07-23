import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/screens/bookings/state/my_bookings_state.dart';

@injectable
class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._useCase) : super(const MyBookingsLoading()) {
    load();
  }

  final AppUseCase _useCase;

  Future<void> load() async {
    emit(const MyBookingsLoading());
    try {
      final bookings = await _useCase.bookings.getMyBookings();
      emit(MyBookingsSuccess(bookings));
    } catch (error, stackTrace) {
      emit(MyBookingsFailure.from(error, stackTrace));
    }
  }
}
