import '../../models/app_models.dart';
import '../../repositories/venue_repository.dart';

class CreateVenueUseCase {
  const CreateVenueUseCase(this._repository);

  final VenueRepository _repository;

  Future<Venue> createVenue(CreateVenueRequest request) {
    return _repository.createVenue(request);
  }
}
