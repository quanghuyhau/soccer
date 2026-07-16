import 'package:injectable/injectable.dart';
import 'package:soccer/data/data_source/services/api_service.dart';
import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/domain/repositories/pitch_repository.dart';

@Injectable(as: PitchRepository)
class PitchRepositoryImpl implements PitchRepository {
  final ApiService _apiService;

  PitchRepositoryImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<BaseResponse<List<PitchPriceResponse>>> getPitchPrices(String pitchId) {
    return _apiService.getPitchPrices(pitchId);
  }

  @override
  Future<BaseResponse<PitchPriceResponse>> createPitchPrice(
    String pitchId,
    PitchPriceRequest request,
  ) {
    return _apiService.createPitchPrice(pitchId, request);
  }

  @override
  Future<BaseResponse<PitchPriceResponse>> updatePitchPrice(
    String priceId,
    PitchPriceRequest request,
  ) {
    return _apiService.updatePitchPrice(priceId, request);
  }

  @override
  Future<BaseResponse<dynamic>> deletePitchPrice(String priceId) {
    return _apiService.deletePitchPrice(priceId);
  }
}
