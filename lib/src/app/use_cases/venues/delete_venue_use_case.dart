import '../../repositories/venue_repository.dart';

class DeleteVenueUseCase {
  const DeleteVenueUseCase(this._repository);

  final VenueRepository _repository;

  Future<void> deleteVenue(String venueId) {
    return _repository.deleteVenue(venueId);
  }
}
