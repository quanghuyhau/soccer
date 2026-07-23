import 'package:soccer/domain/entities/app_models.dart';

abstract interface class VenueRepository {
  Future<List<Venue>> getVenues();
  Future<Venue> getVenue(String venueId);
  Future<List<Venue>> getVenuesByOwner(String ownerId);
  Future<Venue> createVenue(CreateVenueRequest request);
  Future<Venue> updateVenue({
    required String venueId,
    required CreateVenueRequest request,
  });
  Future<void> deleteVenue(String venueId);
}
