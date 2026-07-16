import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';

abstract class PitchRepository {
  Future<BaseResponse<List<PitchPriceResponse>>> getPitchPrices(String pitchId);
  Future<BaseResponse<PitchPriceResponse>> createPitchPrice(
    String pitchId,
    PitchPriceRequest request,
  );
  Future<BaseResponse<PitchPriceResponse>> updatePitchPrice(
    String priceId,
    PitchPriceRequest request,
  );
  Future<BaseResponse<dynamic>> deletePitchPrice(String priceId);
}
