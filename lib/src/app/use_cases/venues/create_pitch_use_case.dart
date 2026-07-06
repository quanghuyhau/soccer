import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';

class CreatePitchParams {
  const CreatePitchParams({
    required this.venueId,
    required this.request,
    this.prices = const [],
  });

  final String venueId;
  final CreatePitchRequest request;
  final List<CreatePitchPriceRequest> prices;
}

class CreatePitchUseCase {
  const CreatePitchUseCase(this._repository);

  final PitchRepository _repository;

  Future<Pitch> call(CreatePitchParams params) async {
    final pitch = await _repository.createPitch(
      venueId: params.venueId,
      request: params.request,
    );

    for (final price in params.prices) {
      await _repository.createPitchPrice(pitchId: pitch.id, request: price);
    }

    return pitch;
  }
}
