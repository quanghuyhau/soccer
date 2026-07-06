import '../models/app_models.dart';

abstract interface class PitchRepository {
  Future<List<Pitch>> getPitches();
  Future<Pitch> getPitch(String pitchId);
  Future<List<Pitch>> getPitchesByVenue(String venueId);
  Future<Pitch> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  });
  Future<List<PitchPrice>> getPitchPrices(String pitchId);
  Future<PitchPrice> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  });
}
