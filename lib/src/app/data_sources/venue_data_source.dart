import '../../core/network/api_client.dart';
import '../models/app_models.dart';
import 'api_envelope_parser.dart';
import 'app_endpoints.dart';

class VenueDataSource {
  const VenueDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VenueResponse>> getVenues() async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.venues,
      parser: parseApiObjectList,
    );
    return response.data.map(VenueResponse.fromJson).toList();
  }

  Future<VenueResponse> getVenue(String venueId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      AppEndpoints.venue(venueId),
      parser: parseApiObject,
    );
    return VenueResponse.fromJson(response.data);
  }

  Future<List<VenueResponse>> getVenuesByOwner(String ownerId) async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.venuesByOwner(ownerId),
      parser: parseApiObjectList,
    );
    return response.data.map(VenueResponse.fromJson).toList();
  }

  Future<VenueResponse> createVenue(CreateVenueRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.venues,
      data: request.toJson(),
      parser: parseApiObject,
    );

    return VenueResponse.fromJson(response.data);
  }

  Future<VenueResponse> updateVenue({
    required String venueId,
    required CreateVenueRequest request,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      AppEndpoints.venue(venueId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return VenueResponse.fromJson(response.data);
  }

  Future<void> deleteVenue(String venueId) async {
    await _apiClient.delete<Object?>(
      AppEndpoints.venue(venueId),
      parser: parseApiSuccess,
    );
  }
}
