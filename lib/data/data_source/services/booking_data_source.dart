import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/api_client.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/data/data_source/services/api_envelope_parser.dart';
import 'package:soccer/data/data_source/services/app_endpoints.dart';

@lazySingleton
class BookingDataSource {
  const BookingDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<BookingResponse> createBooking(CreateBookingRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.bookings,
      data: request.toJson(),
      parser: parseApiObject,
    );

    return BookingResponse.fromJson(response.data);
  }

  Future<List<BookingResponse>> getBookings() async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.bookings,
      parser: parseApiObjectList,
    );
    return response.data.map(BookingResponse.fromJson).toList();
  }

  Future<List<BookingResponse>> getMyBookings() async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.myBookings,
      parser: parseApiObjectList,
    );
    return response.data.map(BookingResponse.fromJson).toList();
  }

  Future<List<BookingResponse>> getBookingsByPitch(String pitchId) async {
    final response = await _apiClient.get<List<Map<String, dynamic>>>(
      AppEndpoints.pitchBookings(pitchId),
      parser: parseApiObjectList,
    );
    return response.data.map(BookingResponse.fromJson).toList();
  }

  Future<BookingResponse> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.bookingStatus(bookingId),
      data: request.toJson(),
      parser: parseApiObject,
    );

    return BookingResponse.fromJson(response.data);
  }
}
