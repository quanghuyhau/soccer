import '../../models/app_models.dart';
import '../../repositories/booking_repository.dart';

class UpdateBookingStatusParams {
  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  final String bookingId;
  final String status;
}

class UpdateBookingStatusUseCase {
  const UpdateBookingStatusUseCase(this._repository);

  final BookingRepository _repository;

  Future<Booking> updateBookingStatus(UpdateBookingStatusParams params) {
    return _repository.updateBookingStatus(
      bookingId: params.bookingId,
      request: UpdateBookingStatusRequest(status: params.status),
    );
  }
}
