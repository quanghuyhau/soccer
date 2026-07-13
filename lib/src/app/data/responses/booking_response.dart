import '../../domain/entities/booking.dart';
import 'json_value.dart';

class BookingResponse extends Booking {
  const BookingResponse({
    required super.id,
    required super.customerUsername,
    required super.customerName,
    required super.customerPhone,
    required super.pitchId,
    required super.pitchName,
    required super.venueId,
    required super.venueName,
    required super.startTime,
    required super.endTime,
    required super.totalPrice,
    required super.status,
    required super.note,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: jsonString(json['id']),
      customerUsername: jsonString(json['customerUsername']),
      customerName: jsonString(json['customerName']),
      customerPhone: jsonString(json['customerPhone']),
      pitchId: jsonString(json['pitchId']),
      pitchName: jsonString(json['pitchName']),
      venueId: jsonString(json['venueId']),
      venueName: jsonString(json['venueName']),
      startTime: jsonDateTime(json['startTime']),
      endTime: jsonDateTime(json['endTime']),
      totalPrice: json['totalPrice'] is num ? json['totalPrice'] as num : 0,
      status: jsonString(json['status'], fallback: 'PENDING'),
      note: jsonString(json['note']),
    );
  }
}
