import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class UpdatePitchParams {
  const UpdatePitchParams({required this.pitchId, required this.request});

  final String pitchId;
  final CreatePitchRequest request;
}

class UpdatePitchUseCase {
  const UpdatePitchUseCase(this._repository);

  final PitchRepository _repository;

  Future<Pitch> call(UpdatePitchParams params) {
    return _repository.updatePitch(
      pitchId: params.pitchId,
      request: params.request,
    );
  }
}
