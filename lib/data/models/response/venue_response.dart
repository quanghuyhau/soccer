import 'package:soccer/domain/entities/venue.dart';
import 'package:soccer/data/models/response/json_value.dart';

class VenueResponse extends Venue {
  const VenueResponse({
    required super.id,
    required super.ownerId,
    required super.code,
    required super.name,
    required super.description,
    required super.phone,
    required super.address,
    required super.openTime,
    required super.closeTime,
    required super.status,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) {
    return VenueResponse(
      id: jsonString(json['id']),
      ownerId: jsonString(json['ownerId']),
      code: jsonString(json['code']),
      name: jsonString(json['name']),
      description: jsonString(json['description']),
      phone: jsonString(json['phone']),
      address: jsonString(json['address']),
      openTime: jsonString(json['openTime']),
      closeTime: jsonString(json['closeTime']),
      status: jsonString(json['status'], fallback: 'ACTIVE'),
    );
  }
}
