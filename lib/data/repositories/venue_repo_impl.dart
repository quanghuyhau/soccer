import 'package:injectable/injectable.dart';
import 'package:soccer/data/data_source/services/api_service.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/domain/repositories/venue_repository.dart';

@Injectable(as: VenueRepository)
class VenueRepositoryImpl implements VenueRepository {
  final ApiService _apiService;

  VenueRepositoryImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<BaseResponse<List<VenueResponse>>> getVenues() {
    return _apiService.getVenues();
  }

  @override
  Future<BaseResponse<List<PitchResponse>>> getPitches(String venueId) {
    return _apiService.getPitches(venueId);
  }
}
