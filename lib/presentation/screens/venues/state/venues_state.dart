import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';

sealed class VenuesState extends AppState<List<Venue>> {
  const VenuesState();
}

class VenuesLoading extends AppLoading<List<Venue>> implements VenuesState {
  const VenuesLoading();
}

class VenuesSuccess extends AppSuccess<List<Venue>> implements VenuesState {
  const VenuesSuccess(super.data);
}

class VenuesFailure extends AppFailure<List<Venue>> implements VenuesState {
  const VenuesFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory VenuesFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<List<Venue>>.from(error, stackTrace);
    return VenuesFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
