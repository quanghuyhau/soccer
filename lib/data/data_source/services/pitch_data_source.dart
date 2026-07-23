import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/api_client.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/data/data_source/services/api_envelope_parser.dart';
import 'package:soccer/data/data_source/services/app_endpoints.dart';

@lazySingleton
class PitchDataSource {
  const PitchDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PitchResponse>> getPitches() async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.pitches,
      parser: parseApiObjectList,
    );
    return response.data.map(PitchResponse.fromJson).toList();
  }

  Future<PitchResponse> getPitch(String pitchId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      AppEndpoints.pitch(pitchId),
      parser: parseApiObject,
    );
    return PitchResponse.fromJson(response.data);
  }

  Future<List<PitchResponse>> getPitchesByVenue(String venueId) async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.pitchesByVenue(venueId),
      parser: parseApiObjectList,
    );
    return response.data.map(PitchResponse.fromJson).toList();
  }

  Future<PitchResponse> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.pitchesByVenue(venueId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return PitchResponse.fromJson(response.data);
  }

  Future<PitchResponse> updatePitch({
    required String pitchId,
    required CreatePitchRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.pitch(pitchId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return PitchResponse.fromJson(response.data);
  }

  Future<void> deletePitch(String pitchId) async {
    await _apiClient.delete<Object?>(
      AppEndpoints.pitch(pitchId),
      parser: parseApiSuccess,
    );
  }

  Future<List<PitchPriceResponse>> getPitchPrices(String pitchId) async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.pitchPrices(pitchId),
      parser: parseApiObjectList,
    );
    return response.data.map(PitchPriceResponse.fromJson).toList();
  }

  Future<PitchPriceResponse> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.pitchPrices(pitchId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return PitchPriceResponse.fromJson(response.data);
  }

  Future<PitchPriceResponse> updatePitchPrice({
    required String priceId,
    required CreatePitchPriceRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.pitchPrice(priceId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return PitchPriceResponse.fromJson(response.data);
  }

  Future<void> deletePitchPrice(String priceId) async {
    await _apiClient.delete<Object?>(
      AppEndpoints.pitchPrice(priceId),
      parser: parseApiSuccess,
    );
  }
}
