import '../../core/network/api_client.dart';
import '../models/app_models.dart';
import 'api_envelope_parser.dart';
import 'app_endpoints.dart';

class BookingDataSource {
  const BookingDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.bookings,
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return BookingModel.fromJson(readResultObject(response.data));
  }

  Future<List<BookingModel>> getBookings() async {
    final json = await _apiClient.getJson(AppEndpoints.bookings);
    return readResultList(
      json,
    ).map((item) => BookingModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<List<BookingModel>> getMyBookings() async {
    final json = await _apiClient.getJson(AppEndpoints.myBookings);
    return readResultList(
      json,
    ).map((item) => BookingModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<List<BookingModel>> getBookingsByPitch(String pitchId) async {
    final json = await _apiClient.getJson(AppEndpoints.pitchBookings(pitchId));
    return readResultList(
      json,
    ).map((item) => BookingModel.fromJson(parseJsonObject(item))).toList();
  }

  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AppEndpoints.bookingStatus(bookingId),
      data: request.toJson(),
      parser: parseJsonObject,
    );

    return BookingModel.fromJson(readResultObject(response.data));
  }
}
