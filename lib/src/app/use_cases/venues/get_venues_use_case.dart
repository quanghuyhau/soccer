import '../../models/app_models.dart';
import '../../repositories/venue_repository.dart';

class GetVenuesUseCase {
  const GetVenuesUseCase(this._repository);

  final VenueRepository _repository;

  Future<List<Venue>> call() {
    return _repository.getVenues();
  }
}
