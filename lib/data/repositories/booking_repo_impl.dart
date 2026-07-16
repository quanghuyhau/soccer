import 'package:injectable/injectable.dart';
import 'package:soccer/data/data_source/services/api_service.dart';
import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/booking_response.dart';
import 'package:soccer/domain/repositories/booking_repository.dart';

@Injectable(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final ApiService _apiService;

  BookingRepositoryImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<BaseResponse<BookingResponse>> createBooking(BookingRequest request) {
    return _apiService.createBooking(request);
  }

  @override
  Future<BaseResponse<List<BookingResponse>>> getBookings() {
    return _apiService.getBookings();
  }

  @override
  Future<BaseResponse<BookingResponse>> getBookingDetail(String bookingId) {
    return _apiService.getBookingDetail(bookingId);
  }

  @override
  Future<BaseResponse<List<BookingResponse>>> getMyBookings() {
    return _apiService.getMyBookings();
  }

  @override
  Future<BaseResponse<List<BookingResponse>>> getBookingsByPitch(String pitchId) {
    return _apiService.getBookingsByPitch(pitchId);
  }

  @override
  Future<BaseResponse<BookingResponse>> updateBookingStatus(
    String bookingId,
    BookingStatusRequest request,
  ) {
    return _apiService.updateBookingStatus(bookingId, request);
  }

  @override
  Future<BaseResponse<dynamic>> deleteBooking(String bookingId) {
    return _apiService.deleteBooking(bookingId);
  }
}
