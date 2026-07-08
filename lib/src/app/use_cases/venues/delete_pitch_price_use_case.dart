import '../../repositories/pitch_repository.dart';

class DeletePitchPriceUseCase {
  const DeletePitchPriceUseCase(this._repository);

  final PitchRepository _repository;

  Future<void> deletePitchPrice(String priceId) {
    return _repository.deletePitchPrice(priceId);
  }
}
