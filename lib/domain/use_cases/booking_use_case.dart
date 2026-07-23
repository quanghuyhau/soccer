import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/repositories/booking_repository.dart';

class UpdateBookingStatusParams {
  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  final String bookingId;
  final String status;
}

@lazySingleton
class BookingUseCase {
  const BookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<Booking> createBooking(CreateBookingRequest request) {
    return _repository.createBooking(request);
  }

  Future<List<Booking>> getAllBookings() {
    return _repository.getBookings();
  }

  Future<List<Booking>> getMyBookings() {
    return _repository.getMyBookings();
  }

  Future<List<Booking>> getBookingsByPitch(String pitchId) {
    return _repository.getBookingsByPitch(pitchId);
  }

  Future<Booking> updateBookingStatus(UpdateBookingStatusParams params) {
    return _repository.updateBookingStatus(
      bookingId: params.bookingId,
      request: UpdateBookingStatusRequest(status: params.status),
    );
  }
}
