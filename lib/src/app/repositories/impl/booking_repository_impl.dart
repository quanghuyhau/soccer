import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../booking_repository.dart';

class BookingRepositoryImpl extends BaseRepository
    implements BookingRepository {
  const BookingRepositoryImpl(this._dataSource);

  final BookingDataSource _dataSource;

  @override
  Future<Booking> createBooking(CreateBookingRequest request) {
    return guard(() => _dataSource.createBooking(request));
  }

  @override
  Future<List<Booking>> getBookings() {
    return guard(_dataSource.getBookings);
  }

  @override
  Future<List<Booking>> getMyBookings() {
    return guard(_dataSource.getMyBookings);
  }

  @override
  Future<List<Booking>> getBookingsByPitch(String pitchId) {
    return guard(() => _dataSource.getBookingsByPitch(pitchId));
  }

  @override
  Future<Booking> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  }) {
    return guard(
      () => _dataSource.updateBookingStatus(
        bookingId: bookingId,
        request: request,
      ),
    );
  }
}
