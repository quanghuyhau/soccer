import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class CreatePitchParams {
  const CreatePitchParams({required this.venueId, required this.request});

  final String venueId;
  final CreatePitchRequest request;
}

class CreatePitchUseCase {
  const CreatePitchUseCase(this._repository);

  final PitchRepository _repository;

  Future<Pitch> call(CreatePitchParams params) {
    return _repository.createPitch(
      venueId: params.venueId,
      request: params.request,
    );
  }
}
