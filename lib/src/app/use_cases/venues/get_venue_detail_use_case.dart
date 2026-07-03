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

  Future<VenueDetailData> call(String venueId) async {
    final venue = await _venueRepository.getVenue(venueId);
    final pitches = await _pitchRepository.getPitchesByVenue(venueId);

    return VenueDetailData(venue: venue, pitches: pitches);
  }
}
