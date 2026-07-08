import '../../models/app_models.dart';
import '../../repositories/booking_repository.dart';

class GetMyBookingsUseCase {
  const GetMyBookingsUseCase(this._repository);

  final BookingRepository _repository;

  Future<List<Booking>> getMyBookings() {
    return _repository.getMyBookings();
  }
}
