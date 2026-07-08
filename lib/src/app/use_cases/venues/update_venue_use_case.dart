import '../../models/app_models.dart';
import '../../repositories/venue_repository.dart';

class UpdateVenueParams {
  const UpdateVenueParams({required this.venueId, required this.request});

  final String venueId;
  final CreateVenueRequest request;
}

class UpdateVenueUseCase {
  const UpdateVenueUseCase(this._repository);

  final VenueRepository _repository;

  Future<Venue> updateVenue(UpdateVenueParams params) {
    return _repository.updateVenue(
      venueId: params.venueId,
      request: params.request,
    );
  }
}
