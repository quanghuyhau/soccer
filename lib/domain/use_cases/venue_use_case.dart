import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/repositories/pitch_repository.dart';
import 'package:soccer/domain/repositories/venue_repository.dart';

class CreatePitchParams {
  const CreatePitchParams({
    required this.venueId,
    required this.request,
    this.prices = const [],
  });

  final String venueId;
  final CreatePitchRequest request;
  final List<CreatePitchPriceRequest> prices;
}

class UpdatePitchParams {
  const UpdatePitchParams({required this.pitchId, required this.request});

  final String pitchId;
  final CreatePitchRequest request;
}

class CreatePitchPriceParams {
  const CreatePitchPriceParams({required this.pitchId, required this.request});
  final String pitchId;
  final CreatePitchPriceRequest request;
}

class UpdatePitchPriceParams {
  const UpdatePitchPriceParams({required this.priceId, required this.request});

  final String priceId;
  final CreatePitchPriceRequest request;
}

class UpdateVenueParams {
  const UpdateVenueParams({required this.venueId, required this.request});

  final String venueId;
  final CreateVenueRequest request;
}

@lazySingleton
class VenueUseCase {
  const VenueUseCase({
    required VenueRepository venueRepository,
    required PitchRepository pitchRepository,
  }) : _venueRepository = venueRepository,
       _pitchRepository = pitchRepository;

  final VenueRepository _venueRepository;
  final PitchRepository _pitchRepository;

  Future<List<Venue>> getVenues() {
    return _venueRepository.getVenues();
  }

  Future<VenueDetailData> getVenueDetail(String venueId) async {
    final venue = await _venueRepository.getVenue(venueId);
    final pitches = await _pitchRepository.getPitchesByVenue(venueId);
    final prices = await Future.wait(
      pitches.map((pitch) => _pitchRepository.getPitchPrices(pitch.id)),
    );
    final pricesByPitch = <String, List<PitchPrice>>{};

    for (var i = 0; i < pitches.length; i++) {
      pricesByPitch[pitches[i].id] = prices[i];
    }

    return VenueDetailData(
      venue: venue,
      pitches: pitches,
      pricesByPitch: pricesByPitch,
    );
  }

  Future<List<Venue>> getVenuesByOwner(String ownerId) {
    return _venueRepository.getVenuesByOwner(ownerId);
  }

  Future<Venue> createVenue(CreateVenueRequest request) {
    return _venueRepository.createVenue(request);
  }

  Future<Venue> updateVenue(UpdateVenueParams params) {
    return _venueRepository.updateVenue(
      venueId: params.venueId,
      request: params.request,
    );
  }

  Future<void> deleteVenue(String venueId) {
    return _venueRepository.deleteVenue(venueId);
  }

  Future<Pitch> createPitch(CreatePitchParams params) async {
    final pitch = await _pitchRepository.createPitch(
      venueId: params.venueId,
      request: params.request,
    );

    for (final price in params.prices) {
      await _pitchRepository.createPitchPrice(
        pitchId: pitch.id,
        request: price,
      );
    }

    return pitch;
  }

  Future<Pitch> updatePitch(UpdatePitchParams params) {
    return _pitchRepository.updatePitch(
      pitchId: params.pitchId,
      request: params.request,
    );
  }

  Future<void> deletePitch(String pitchId) {
    return _pitchRepository.deletePitch(pitchId);
  }

  Future<List<PitchPrice>> getPitchPrices(String pitchId) {
    return _pitchRepository.getPitchPrices(pitchId);
  }

  Future<PitchPrice> createPitchPrice(CreatePitchPriceParams params) {
    return _pitchRepository.createPitchPrice(
      pitchId: params.pitchId,
      request: params.request,
    );
  }

  Future<PitchPrice> updatePitchPrice(UpdatePitchPriceParams params) {
    return _pitchRepository.updatePitchPrice(
      priceId: params.priceId,
      request: params.request,
    );
  }

  Future<void> deletePitchPrice(String priceId) {
    return _pitchRepository.deletePitchPrice(priceId);
  }
}
