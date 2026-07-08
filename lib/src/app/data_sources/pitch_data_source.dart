import '../../core/network/api_client.dart';
import '../models/app_models.dart';
import 'api_envelope_parser.dart';
import 'app_endpoints.dart';

class PitchDataSource {
  const PitchDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PitchModel>> getPitches() async {
    final json = await _apiClient.getJson(AppEndpoints.pitches);
    return readResultList(
      json,
    ).map((item) => PitchModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<PitchModel> getPitch(String pitchId) async {
    final json = await _apiClient.getJson(AppEndpoints.pitch(pitchId));
    return PitchModel.fromJson(readResultObject(json));
  }

  Future<List<PitchModel>> getPitchesByVenue(String venueId) async {
    final json = await _apiClient.getJson(AppEndpoints.pitchesByVenue(venueId));
    return readResultList(
      json,
    ).map((item) => PitchModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<PitchModel> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.pitchesByVenue(venueId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return PitchModel.fromJson(readResultObject(response.data));
  }

  Future<PitchModel> updatePitch({
    required String pitchId,
    required CreatePitchRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.pitch(pitchId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return PitchModel.fromJson(readResultObject(response.data));
  }

  Future<void> deletePitch(String pitchId) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      AppEndpoints.pitch(pitchId),
      parser: parseJsonObject,
    );

    ensureSuccessfulEnvelope(response.data);
  }

  Future<List<PitchPriceModel>> getPitchPrices(String pitchId) async {
    final json = await _apiClient.getJson(AppEndpoints.pitchPrices(pitchId));
    return readResultList(
      json,
    ).map((item) => PitchPriceModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<PitchPriceModel> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.pitchPrices(pitchId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return PitchPriceModel.fromJson(readResultObject(response.data));
  }

  Future<PitchPriceModel> updatePitchPrice({
    required String priceId,
    required CreatePitchPriceRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.pitchPrice(priceId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return PitchPriceModel.fromJson(readResultObject(response.data));
  }

  Future<void> deletePitchPrice(String priceId) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      AppEndpoints.pitchPrice(priceId),
      parser: parseJsonObject,
    );

    ensureSuccessfulEnvelope(response.data);
  }
}
