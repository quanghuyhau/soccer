import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/booking_response.dart';

abstract class BookingRepository {
  Future<BaseResponse<BookingResponse>> createBooking(BookingRequest request);
  Future<BaseResponse<List<BookingResponse>>> getBookings();
  Future<BaseResponse<BookingResponse>> getBookingDetail(String bookingId);
  Future<BaseResponse<List<BookingResponse>>> getMyBookings();
  Future<BaseResponse<List<BookingResponse>>> getBookingsByPitch(String pitchId);
  Future<BaseResponse<BookingResponse>> updateBookingStatus(
    String bookingId,
    BookingStatusRequest request,
  );
  Future<BaseResponse<dynamic>> deleteBooking(String bookingId);
}
