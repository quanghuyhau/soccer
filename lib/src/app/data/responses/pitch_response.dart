import '../../domain/entities/pitch.dart';
import 'json_value.dart';

class PitchResponse extends Pitch {
  const PitchResponse({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.code,
    required super.name,
    required super.description,
    required super.type,
    required super.size,
    required super.surface,
    required super.status,
  });

  factory PitchResponse.fromJson(Map<String, dynamic> json) {
    return PitchResponse(
      id: jsonString(json['id']),
      venueId: jsonString(json['venueId']),
      venueName: jsonString(json['venueName']),
      code: jsonString(json['code']),
      name: jsonString(json['name']),
      description: jsonString(json['description']),
      type: jsonString(json['type']),
      size: jsonString(json['size']),
      surface: jsonString(json['surface']),
      status: jsonString(json['status'], fallback: 'ACTIVE'),
    );
  }
}
