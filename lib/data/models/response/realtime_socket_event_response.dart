import 'package:soccer/domain/entities/realtime_event.dart';

// Model ở tầng data nhận JSON socket và chuyển thành entity RealtimeEvent cho tầng trên dùng.
class RealtimeSocketEventResponse extends RealtimeEvent {
  const RealtimeSocketEventResponse({
    required super.type,
    required super.data,
    required super.receivedAt,
  });

  // Chuyển JSON backend gửi qua socket thành event app hiểu được.
  factory RealtimeSocketEventResponse.fromJson(Map<String, dynamic> json) {
    return RealtimeSocketEventResponse(
      type: _eventType(json['type'] ?? json['event']),
      data: _eventData(json['data'] ?? json['result']),
      receivedAt: DateTime.now(),
    );
  }
}

// Map chuỗi type từ backend sang enum để controller check dễ hơn.
RealtimeEventType _eventType(Object? value) {
  final raw = value is String ? value : '';

  return switch (raw) {
    'booking_created' || 'BOOKING_CREATED' => RealtimeEventType.bookingCreated,
    'booking_updated' || 'BOOKING_UPDATED' => RealtimeEventType.bookingUpdated,
    'booking_cancelled' ||
    'BOOKING_CANCELLED' => RealtimeEventType.bookingCancelled,
    _ => RealtimeEventType.unknown,
  };
}

// Lấy payload event; nếu backend không gửi object thì trả object rỗng để tránh crash.
Map<String, dynamic> _eventData(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  return const {};
}
