import 'package:soccer/presentation/common/base_state.dart';
import 'package:soccer/presentation/screens/owner/state/owner_state.dart';

sealed class OwnerDashboardState extends AppState<OwnerDashboardData> {
  const OwnerDashboardState();
}

class OwnerDashboardLoading extends AppLoading<OwnerDashboardData>
    implements OwnerDashboardState {
  const OwnerDashboardLoading();
}

class OwnerDashboardSuccess extends AppSuccess<OwnerDashboardData>
    implements OwnerDashboardState {
  const OwnerDashboardSuccess(super.data);
}

class OwnerDashboardFailure extends AppFailure<OwnerDashboardData>
    implements OwnerDashboardState {
  const OwnerDashboardFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory OwnerDashboardFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<OwnerDashboardData>.from(error, stackTrace);
    return OwnerDashboardFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
