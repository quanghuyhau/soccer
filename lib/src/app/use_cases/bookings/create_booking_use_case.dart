import '../../models/app_models.dart';
import '../../repositories/booking_repository.dart';

class CreateBookingUseCase {
  const CreateBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<Booking> createBooking(CreateBookingRequest request) {
    return _repository.createBooking(request);
  }
}
