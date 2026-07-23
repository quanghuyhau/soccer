// Các loại event socket mà app đang quan tâm.
enum RealtimeEventType {
  bookingCreated,
  bookingUpdated,
  bookingCancelled,
  unknown,
}

// Entity sạch app dùng sau khi socket response đã được parse.
class RealtimeEvent {
  const RealtimeEvent({
    required this.type,
    required this.data,
    required this.receivedAt,
  });

  // Loại event đã được chuẩn hóa từ chuỗi backend gửi về.
  final RealtimeEventType type;

  // Payload gốc của event; giữ dạng map để sau này backend thêm field vẫn không phải sửa entity ngay.
  final Map<String, dynamic> data;

  // Thời điểm app nhận event, dùng được cho log hoặc debug realtime.
  final DateTime receivedAt;

  // Check nhanh event có liên quan booking không để controller quyết định reload dashboard.
  bool get isBookingEvent {
    return type == RealtimeEventType.bookingCreated ||
        type == RealtimeEventType.bookingUpdated ||
        type == RealtimeEventType.bookingCancelled;
  }
}
