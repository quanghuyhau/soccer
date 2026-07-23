import 'package:soccer/domain/entities/pitch.dart';
import 'package:soccer/domain/entities/pitch_price.dart';
import 'package:soccer/domain/entities/venue.dart';

class VenueDetailData {
  const VenueDetailData({
    required this.venue,
    required this.pitches,
    this.pricesByPitch = const {},
  });

  final Venue venue;
  final List<Pitch> pitches;
  final Map<String, List<PitchPrice>> pricesByPitch;

  List<PitchPrice> pricesOf(String pitchId) {
    return pricesByPitch[pitchId] ?? const [];
  }
}
