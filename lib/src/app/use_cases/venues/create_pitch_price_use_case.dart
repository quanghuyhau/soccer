import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class CreatePitchPriceParams {
  const CreatePitchPriceParams({required this.pitchId, required this.request});

  final String pitchId;
  final CreatePitchPriceRequest request;
}

class CreatePitchPriceUseCase {
  const CreatePitchPriceUseCase(this._repository);

  final PitchRepository _repository;

  Future<PitchPrice> createPitchPrice(CreatePitchPriceParams params) {
    return _repository.createPitchPrice(
      pitchId: params.pitchId,
      request: params.request,
    );
  }
}
