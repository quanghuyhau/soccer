import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../../repositories/venue_repository.dart';

class VenueRepositoryImpl extends BaseRepository implements VenueRepository {
  const VenueRepositoryImpl(this._dataSource);

  final VenueDataSource _dataSource;

  @override
  Future<List<Venue>> getVenues() {
    return executeDataSourceRequest(_dataSource.getVenues);
  }

  @override
  Future<Venue> getVenue(String venueId) {
    return executeDataSourceRequest(() => _dataSource.getVenue(venueId));
  }

  @override
  Future<List<Venue>> getVenuesByOwner(String ownerId) {
    return executeDataSourceRequest(
      () => _dataSource.getVenuesByOwner(ownerId),
    );
  }

  @override
  Future<Venue> createVenue(CreateVenueRequest request) {
    return executeDataSourceRequest(() => _dataSource.createVenue(request));
  }

  @override
  Future<Venue> updateVenue({
    required String venueId,
    required CreateVenueRequest request,
  }) {
    return executeDataSourceRequest(
      () => _dataSource.updateVenue(venueId: venueId, request: request),
    );
  }

  @override
  Future<void> deleteVenue(String venueId) {
    return executeDataSourceRequest(() => _dataSource.deleteVenue(venueId));
  }
}
