import '../../../core/repository/base_repository.dart';
import '../../data_sources/app_data_source.dart';
import '../../models/app_models.dart';
import '../venue_repository.dart';

class VenueRepositoryImpl extends BaseRepository implements VenueRepository {
  const VenueRepositoryImpl(this._dataSource);

  final VenueDataSource _dataSource;

  @override
  Future<List<Venue>> getVenues() {
    return guard(_dataSource.getVenues);
  }

  @override
  Future<Venue> getVenue(String venueId) {
    return guard(() => _dataSource.getVenue(venueId));
  }

  @override
  Future<List<Venue>> getVenuesByOwner(String ownerId) {
    return guard(() => _dataSource.getVenuesByOwner(ownerId));
  }

  @override
  Future<Venue> createVenue(CreateVenueRequest request) {
    return guard(() => _dataSource.createVenue(request));
  }
}
