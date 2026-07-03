import '../../models/app_models.dart';
import '../../repositories/venue_repository.dart';

class GetVenuesByOwnerUseCase {
  const GetVenuesByOwnerUseCase(this._repository);

  final VenueRepository _repository;

  Future<List<Venue>> call(String ownerId) {
    return _repository.getVenuesByOwner(ownerId);
  }
}
