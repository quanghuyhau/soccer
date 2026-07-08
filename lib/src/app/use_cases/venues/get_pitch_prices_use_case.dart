import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class GetPitchPricesUseCase {
  const GetPitchPricesUseCase(this._repository);

  final PitchRepository _repository;

  Future<List<PitchPrice>> getPitchPrices(String pitchId) {
    return _repository.getPitchPrices(pitchId);
  }
}
