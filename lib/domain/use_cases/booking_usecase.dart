import 'package:injectable/injectable.dart';
import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/base_response.dart';
import 'package:soccer/data/models/response/booking_response.dart';
import 'package:soccer/domain/repositories/booking_repository.dart';

@injectable
class BookingUseCase {
  final BookingRepository _bookingRepository;

  BookingUseCase({
    required BookingRepository bookingRepository,
  }) : _bookingRepository = bookingRepository;

  Future<BaseResponse<BookingResponse>> create(BookingRequest request) {
    return _bookingRepository.createBooking(request);
  }

  Future<BaseResponse<List<BookingResponse>>> getAll() {
    return _bookingRepository.getBookings();
  }

  Future<BaseResponse<BookingResponse>> getDetail(String bookingId) {
    return _bookingRepository.getBookingDetail(bookingId);
  }

  Future<BaseResponse<List<BookingResponse>>> getMyBookings() {
    return _bookingRepository.getMyBookings();
  }

  Future<BaseResponse<List<BookingResponse>>> getBookingsByPitch(String pitchId) {
    return _bookingRepository.getBookingsByPitch(pitchId);
  }

  Future<BaseResponse<BookingResponse>> updateStatus(
    String bookingId,
    String status,
  ) {
    return _bookingRepository.updateBookingStatus(
      bookingId,
      BookingStatusRequest(status: status),
    );
  }

  Future<BaseResponse<dynamic>> delete(String bookingId) {
    return _bookingRepository.deleteBooking(bookingId);
  }
}
