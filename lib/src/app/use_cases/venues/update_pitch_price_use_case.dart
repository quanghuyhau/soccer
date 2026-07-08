import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class UpdatePitchPriceParams {
  const UpdatePitchPriceParams({required this.priceId, required this.request});

  final String priceId;
  final CreatePitchPriceRequest request;
}

class UpdatePitchPriceUseCase {
  const UpdatePitchPriceUseCase(this._repository);

  final PitchRepository _repository;

  Future<PitchPrice> updatePitchPrice(UpdatePitchPriceParams params) {
    return _repository.updatePitchPrice(
      priceId: params.priceId,
      request: params.request,
    );
  }
}
