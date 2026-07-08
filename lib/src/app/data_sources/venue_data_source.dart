import '../../core/network/api_client.dart';
import '../models/app_models.dart';
import 'api_envelope_parser.dart';
import 'app_endpoints.dart';

class VenueDataSource {
  const VenueDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VenueModel>> getVenues() async {
    final json = await _apiClient.getJson(AppEndpoints.venues);
    return readResultList(
      json,
    ).map((item) => VenueModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<VenueModel> getVenue(String venueId) async {
    final json = await _apiClient.getJson(AppEndpoints.venue(venueId));
    return VenueModel.fromJson(readResultObject(json));
  }

  Future<List<VenueModel>> getVenuesByOwner(String ownerId) async {
    final json = await _apiClient.getJson(AppEndpoints.venuesByOwner(ownerId));
    return readResultList(
      json,
    ).map((item) => VenueModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<VenueModel> createVenue(CreateVenueRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.venues,
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return VenueModel.fromJson(readResultObject(response.data));
  }

  Future<VenueModel> updateVenue({
    required String venueId,
    required CreateVenueRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.venue(venueId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return VenueModel.fromJson(readResultObject(response.data));
  }

  Future<void> deleteVenue(String venueId) async {
    final response = await _apiClient.delete<Map<String, dynamic>>(
      AppEndpoints.venue(venueId),
      parser: parseJsonObject,
    );

    ensureSuccessfulEnvelope(response.data);
  }
}
