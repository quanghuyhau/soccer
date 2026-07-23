import 'package:soccer/presentation/common/base_state.dart';

sealed class VenueMutationState extends AppState<Object?> {
  const VenueMutationState();
}

class VenueMutationInitial extends AppInitial<Object?>
    implements VenueMutationState {
  const VenueMutationInitial();
}

class VenueMutationLoading extends AppLoading<Object?>
    implements VenueMutationState {
  const VenueMutationLoading();
}

class VenueMutationSuccess extends AppSuccess<Object?>
    implements VenueMutationState {
  const VenueMutationSuccess(super.data);
}

class VenueMutationFailure extends AppFailure<Object?>
    implements VenueMutationState {
  const VenueMutationFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory VenueMutationFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<Object?>.from(error, stackTrace);
    return VenueMutationFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
