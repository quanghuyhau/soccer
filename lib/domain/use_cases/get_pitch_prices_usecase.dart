import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/domain/repositories/pitch_repository.dart';

@injectable
class GetPitchPricesUseCase {
  final PitchRepository _pitchRepository;

  GetPitchPricesUseCase({
    required PitchRepository pitchRepository,
  }) : _pitchRepository = pitchRepository;

  Future<BaseResponse<List<PitchPriceResponse>>> getPrices(String pitchId) {
    return _pitchRepository.getPitchPrices(pitchId);
  }

  Future<BaseResponse<PitchPriceResponse>> createPrice(
    String pitchId,
    PitchPriceRequest request,
  ) {
    return _pitchRepository.createPitchPrice(pitchId, request);
  }

  Future<BaseResponse<PitchPriceResponse>> updatePrice(
    String priceId,
    PitchPriceRequest request,
  ) {
    return _pitchRepository.updatePitchPrice(priceId, request);
  }

  Future<BaseResponse<dynamic>> deletePrice(String priceId) {
    return _pitchRepository.deletePitchPrice(priceId);
  }
}
