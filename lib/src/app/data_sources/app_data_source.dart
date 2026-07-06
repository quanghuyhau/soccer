import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/app_models.dart';

final appDataSourceProvider = Provider<AppDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AppDataSource(
    auth: AuthDataSource(apiClient),
    venues: VenueDataSource(apiClient),
    pitches: PitchDataSource(apiClient),
    bookings: BookingDataSource(apiClient),
  );
});

class AppDataSource {
  const AppDataSource({
    required this.auth,
    required this.venues,
    required this.pitches,
    required this.bookings,
  });

  final AuthDataSource auth;
  final VenueDataSource venues;
  final PitchDataSource pitches;
  final BookingDataSource bookings;
}

class AuthDataSource {
  const AuthDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensModel> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return AuthTokensModel.fromJson(_resultObject(response.data));
  }

  Future<AppUserModel> register(RegisterRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/auth/register',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return AppUserModel.fromJson(_resultObject(response.data));
  }

  Future<AppUserModel> getCurrentUser({String? accessToken}) async {
    final response = await _apiClient.request<Map<String, dynamic>>(
      '/api/users/me',
      parser: _asJsonObject,
      options: accessToken == null || accessToken.isEmpty
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return AppUserModel.fromJson(_resultObject(response.data));
  }
}

class VenueDataSource {
  const VenueDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VenueModel>> getVenues() async {
    final json = await _apiClient.getJson('/api/venues');
    return _resultList(
      json,
    ).map((item) => VenueModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<VenueModel> getVenue(String venueId) async {
    final json = await _apiClient.getJson('/api/venues/$venueId');
    return VenueModel.fromJson(_resultObject(json));
  }

  Future<List<VenueModel>> getVenuesByOwner(String ownerId) async {
    final json = await _apiClient.getJson('/api/venues/owner/$ownerId');
    return _resultList(
      json,
    ).map((item) => VenueModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<VenueModel> createVenue(CreateVenueRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/venues',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return VenueModel.fromJson(_resultObject(response.data));
  }
}

class PitchDataSource {
  const PitchDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PitchModel>> getPitches() async {
    final json = await _apiClient.getJson('/api/pitches');
    return _resultList(
      json,
    ).map((item) => PitchModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<PitchModel> getPitch(String pitchId) async {
    final json = await _apiClient.getJson('/api/pitches/$pitchId');
    return PitchModel.fromJson(_resultObject(json));
  }

  Future<List<PitchModel>> getPitchesByVenue(String venueId) async {
    final json = await _apiClient.getJson('/api/venues/$venueId/pitches');
    return _resultList(
      json,
    ).map((item) => PitchModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<PitchModel> createPitch({
    required String venueId,
    required CreatePitchRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/venues/$venueId/pitches',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return PitchModel.fromJson(_resultObject(response.data));
  }

  Future<List<PitchPriceModel>> getPitchPrices(String pitchId) async {
    final json = await _apiClient.getJson('/api/pitches/$pitchId/prices');
    return _resultList(
      json,
    ).map((item) => PitchPriceModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<PitchPriceModel> createPitchPrice({
    required String pitchId,
    required CreatePitchPriceRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/pitches/$pitchId/prices',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return PitchPriceModel.fromJson(_resultObject(response.data));
  }
}

class BookingDataSource {
  const BookingDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/bookings',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return BookingModel.fromJson(_resultObject(response.data));
  }

  Future<List<BookingModel>> getBookings() async {
    final json = await _apiClient.getJson('/api/bookings');
    return _resultList(
      json,
    ).map((item) => BookingModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<List<BookingModel>> getMyBookings() async {
    final json = await _apiClient.getJson('/api/bookings/me');
    return _resultList(
      json,
    ).map((item) => BookingModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<List<BookingModel>> getBookingsByPitch(String pitchId) async {
    final json = await _apiClient.getJson('/api/pitches/$pitchId/bookings');
    return _resultList(
      json,
    ).map((item) => BookingModel.fromJson(_asJsonObject(item))).toList();
  }

  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/api/bookings/$bookingId/status',
      data: request.toJson(),
      parser: _asJsonObject,
    );

    return BookingModel.fromJson(_resultObject(response.data));
  }
}

Map<String, dynamic> _asJsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  throw const ParsingException('Response data is not a JSON object.');
}

Map<String, dynamic> _resultObject(Map<String, dynamic> envelope) {
  final code = envelope['code'];
  final message = envelope['message'];
  final result = envelope['result'];

  if (code is int && code >= 400) {
    throw ServerException(
      message is String ? message : 'Request failed.',
      statusCode: code,
    );
  }

  if (result is Map<String, dynamic>) {
    return result;
  }

  throw const ParsingException('API result is not a JSON object.');
}

List<dynamic> _resultList(Map<String, dynamic> envelope) {
  final code = envelope['code'];
  final message = envelope['message'];
  final result = envelope['result'];

  if (code is int && code >= 400) {
    throw ServerException(
      message is String ? message : 'Request failed.',
      statusCode: code,
    );
  }

  if (result is List<dynamic>) {
    return result;
  }

  throw const ParsingException('API result is not a JSON array.');
}
