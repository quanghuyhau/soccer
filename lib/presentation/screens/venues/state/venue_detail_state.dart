import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';

sealed class VenueDetailState extends AppState<VenueDetailData> {
  const VenueDetailState();
}

class VenueDetailLoading extends AppLoading<VenueDetailData>
    implements VenueDetailState {
  const VenueDetailLoading();
}

class VenueDetailSuccess extends AppSuccess<VenueDetailData>
    implements VenueDetailState {
  const VenueDetailSuccess(super.data);
}

class VenueDetailFailure extends AppFailure<VenueDetailData>
    implements VenueDetailState {
  const VenueDetailFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory VenueDetailFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<VenueDetailData>.from(error, stackTrace);
    return VenueDetailFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
