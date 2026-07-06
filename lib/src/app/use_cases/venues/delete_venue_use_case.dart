import '../../repositories/venue_repository.dart';

class DeleteVenueUseCase {
  const DeleteVenueUseCase(this._repository);

  final VenueRepository _repository;

  Future<void> call(String venueId) {
    return _repository.deleteVenue(venueId);
  }
}
