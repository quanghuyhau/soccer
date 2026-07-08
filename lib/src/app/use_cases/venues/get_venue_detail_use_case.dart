import '../../models/app_models.dart';
import '../../repositories/pitch_repository.dart';
import '../../repositories/venue_repository.dart';

class GetVenueDetailUseCase {
  const GetVenueDetailUseCase({
    required VenueRepository venueRepository,
    required PitchRepository pitchRepository,
  }) : _venueRepository = venueRepository,
       _pitchRepository = pitchRepository;

  final VenueRepository _venueRepository;
  final PitchRepository _pitchRepository;

  Future<VenueDetailData> getVenueDetail(String venueId) async {
    final venue = await _venueRepository.getVenue(venueId);
    final pitches = await _pitchRepository.getPitchesByVenue(venueId);
    final prices = await Future.wait(
      pitches.map((pitch) => _pitchRepository.getPitchPrices(pitch.id)),
    );
    final pricesByPitch = <String, List<PitchPrice>>{};

    for (var i = 0; i < pitches.length; i++) {
      pricesByPitch[pitches[i].id] = prices[i];
    }

    return VenueDetailData(
      venue: venue,
      pitches: pitches,
      pricesByPitch: pricesByPitch,
    );
  }
}
