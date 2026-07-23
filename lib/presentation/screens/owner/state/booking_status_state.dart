import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';

sealed class BookingStatusState extends AppState<Booking?> {
  const BookingStatusState();
}

class BookingStatusInitial extends AppInitial<Booking?>
    implements BookingStatusState {
  const BookingStatusInitial();
}

class BookingStatusLoading extends AppLoading<Booking?>
    implements BookingStatusState {
  const BookingStatusLoading();
}

class BookingStatusSuccess extends AppSuccess<Booking?>
    implements BookingStatusState {
  const BookingStatusSuccess(super.data);
}

class BookingStatusFailure extends AppFailure<Booking?>
    implements BookingStatusState {
  const BookingStatusFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory BookingStatusFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<Booking?>.from(error, stackTrace);
    return BookingStatusFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
