import '../../models/app_models.dart';
import '../../repositories/booking_repository.dart';

class GetAllBookingsUseCase {
  const GetAllBookingsUseCase(this._repository);

  final BookingRepository _repository;

  Future<List<Booking>> call() {
    return _repository.getBookings();
  }
}
