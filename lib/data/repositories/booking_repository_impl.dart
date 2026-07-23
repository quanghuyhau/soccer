import 'package:injectable/injectable.dart';

import 'package:soccer/data/repositories/base_repository.dart';
import 'package:soccer/data/data_source/services/app_data_source.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/repositories/booking_repository.dart';

@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl extends BaseRepository
    implements BookingRepository {
  const BookingRepositoryImpl(this._dataSource);

  final BookingDataSource _dataSource;

  @override
  Future<Booking> createBooking(CreateBookingRequest request) {
    return executeDataSourceRequest(() => _dataSource.createBooking(request));
  }

  @override
  Future<List<Booking>> getBookings() {
    return executeDataSourceRequest(_dataSource.getBookings);
  }

  @override
  Future<List<Booking>> getMyBookings() {
    return executeDataSourceRequest(_dataSource.getMyBookings);
  }

  @override
  Future<List<Booking>> getBookingsByPitch(String pitchId) {
    return executeDataSourceRequest(
      () => _dataSource.getBookingsByPitch(pitchId),
    );
  }

  @override
  Future<Booking> updateBookingStatus({
    required String bookingId,
    required UpdateBookingStatusRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.updateBookingStatus(
        bookingId: bookingId,
        request: request,
      ),
    );
  }
}
