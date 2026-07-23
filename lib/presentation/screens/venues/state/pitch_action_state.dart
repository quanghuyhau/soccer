import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/presentation/common/base_state.dart';

sealed class CreatePitchState extends AppState<Pitch?> {
  const CreatePitchState();
}

class CreatePitchInitial extends AppInitial<Pitch?>
    implements CreatePitchState {
  const CreatePitchInitial();
}

class CreatePitchLoading extends AppLoading<Pitch?>
    implements CreatePitchState {
  const CreatePitchLoading();
}

class CreatePitchSuccess extends AppSuccess<Pitch?>
    implements CreatePitchState {
  const CreatePitchSuccess(super.data);
}

class CreatePitchFailure extends AppFailure<Pitch?>
    implements CreatePitchState {
  const CreatePitchFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory CreatePitchFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<Pitch?>.from(error, stackTrace);
    return CreatePitchFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}

sealed class PitchMutationState extends AppState<Object?> {
  const PitchMutationState();
}

class PitchMutationInitial extends AppInitial<Object?>
    implements PitchMutationState {
  const PitchMutationInitial();
}

class PitchMutationLoading extends AppLoading<Object?>
    implements PitchMutationState {
  const PitchMutationLoading();
}

class PitchMutationSuccess extends AppSuccess<Object?>
    implements PitchMutationState {
  const PitchMutationSuccess(super.data);
}

class PitchMutationFailure extends AppFailure<Object?>
    implements PitchMutationState {
  const PitchMutationFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory PitchMutationFailure.from(Object error, [StackTrace? stackTrace]) {
    final failure = AppFailure<Object?>.from(error, stackTrace);
    return PitchMutationFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}

sealed class PitchPriceMutationState extends AppState<Object?> {
  const PitchPriceMutationState();
}

class PitchPriceMutationInitial extends AppInitial<Object?>
    implements PitchPriceMutationState {
  const PitchPriceMutationInitial();
}

class PitchPriceMutationLoading extends AppLoading<Object?>
    implements PitchPriceMutationState {
  const PitchPriceMutationLoading();
}

class PitchPriceMutationSuccess extends AppSuccess<Object?>
    implements PitchPriceMutationState {
  const PitchPriceMutationSuccess(super.data);
}

class PitchPriceMutationFailure extends AppFailure<Object?>
    implements PitchPriceMutationState {
  const PitchPriceMutationFailure({
    required super.message,
    super.backendCode,
    super.statusCode,
    super.errors,
    super.error,
    super.stackTrace,
  });

  factory PitchPriceMutationFailure.from(
    Object error, [
    StackTrace? stackTrace,
  ]) {
    final failure = AppFailure<Object?>.from(error, stackTrace);
    return PitchPriceMutationFailure(
      message: failure.message,
      backendCode: failure.backendCode,
      statusCode: failure.statusCode,
      errors: failure.errors,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
