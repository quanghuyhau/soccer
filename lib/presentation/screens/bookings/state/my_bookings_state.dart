import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';

sealed class MyBookingsState extends AppState<List<Booking>> {
  const MyBookingsState();
}

class MyBookingsLoading extends AppLoading<List<Booking>>
    implements MyBookingsState {
  const MyBookingsLoading();
}

class MyBookingsSuccess extends AppSuccess<List<Booking>>
    implements MyBookingsState {
  const MyBookingsSuccess(super.data);
}

class MyBookingsFailure extends AppFailure<List<Booking>>
    implements MyBookingsState {
  const MyBookingsFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory MyBookingsFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<List<Booking>>.from(error, stackTrace);
    return MyBookingsFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
