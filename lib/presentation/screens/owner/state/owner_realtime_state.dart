import 'package:soccer/presentation/common/base_state.dart';

sealed class OwnerRealtimeState extends AppState<void> {
  const OwnerRealtimeState();
}

class OwnerRealtimeInitial extends AppInitial<void>
    implements OwnerRealtimeState {
  const OwnerRealtimeInitial();
}

class OwnerRealtimeConnecting extends AppLoading<void>
    implements OwnerRealtimeState {
  const OwnerRealtimeConnecting();
}

class OwnerRealtimeConnected extends AppSuccess<void>
    implements OwnerRealtimeState {
  const OwnerRealtimeConnected() : super();
}

class OwnerRealtimeFailure extends AppFailure<void>
    implements OwnerRealtimeState {
  const OwnerRealtimeFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory OwnerRealtimeFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<void>.from(error, stackTrace);
    return OwnerRealtimeFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
