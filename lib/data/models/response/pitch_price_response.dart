import 'package:soccer/domain/entities/pitch_price.dart';
import 'package:soccer/data/models/response/json_value.dart';

class PitchPriceResponse extends PitchPrice {
  const PitchPriceResponse({
    required super.id,
    required super.pitchId,
    required super.pitchName,
    required super.startTime,
    required super.endTime,
    required super.slotMinutes,
    required super.priceType,
    required super.price,
  });

  factory PitchPriceResponse.fromJson(Map<String, dynamic> json) {
    return PitchPriceResponse(
      id: jsonString(json['id']),
      pitchId: jsonString(json['pitchId']),
      pitchName: jsonString(json['pitchName']),
      startTime: jsonString(json['startTime']),
      endTime: jsonString(json['endTime']),
      slotMinutes: json['slotMinutes'] is int ? json['slotMinutes'] as int : 90,
      priceType: jsonString(json['priceType'], fallback: 'NORMAL'),
      price: json['price'] is num
          ? json['price'] as num
          : json['pricePerHour'] is num
          ? json['pricePerHour'] as num
          : 0,
    );
  }
}
