import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/data/models/response/pitch_response.dart';

abstract class VenueRepository {
  Future<BaseResponse<List<VenueResponse>>> getVenues();
  Future<BaseResponse<List<PitchResponse>>> getPitches(String venueId);
}
