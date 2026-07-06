import '../../repositories/pitch_repository.dart';

class DeletePitchUseCase {
  const DeletePitchUseCase(this._repository);

  final PitchRepository _repository;

  Future<void> call(String pitchId) {
    return _repository.deletePitch(pitchId);
  }
}
