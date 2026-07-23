import 'package:soccer/domain/entities/app_models.dart';

abstract interface class BookingRepository {
  Future<Booking> createBooking(CreateBookingRequest request);
  Future<List<Booking>> getBookings();
  Future<List<Booking>> getMyBookings();
  Future<List<Booking>> getBookingsByPitch(String pitchId);
  Future<Booking> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  });
}
