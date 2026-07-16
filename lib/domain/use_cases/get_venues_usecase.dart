import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/domain/repositories/venue_repository.dart';

@injectable
class GetVenuesUseCase {
  final VenueRepository _venueRepository;

  GetVenuesUseCase({
    required VenueRepository venueRepository,
  }) : _venueRepository = venueRepository;

  Future<BaseResponse<List<VenueResponse>>> execute() {
    return _venueRepository.getVenues();
  }
}
