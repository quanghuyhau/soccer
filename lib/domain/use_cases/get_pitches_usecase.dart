import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/domain/repositories/venue_repository.dart';

@injectable
class GetPitchesUseCase {
  final VenueRepository _venueRepository;

  GetPitchesUseCase({
    required VenueRepository venueRepository,
  }) : _venueRepository = venueRepository;

  Future<BaseResponse<List<PitchResponse>>> execute(String venueId) {
    return _venueRepository.getPitches(venueId);
  }
}
