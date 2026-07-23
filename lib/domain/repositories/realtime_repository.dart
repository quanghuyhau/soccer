import 'package:soccer/domain/entities/realtime_event.dart';

// Contract realtime ở tầng domain: app cần connect, nghe event và disconnect.
abstract interface class RealtimeRepository {
  // Stream event nghiệp vụ, ví dụ booking_created/booking_updated.
  Stream<RealtimeEvent> get events;

  // Stream trạng thái kỹ thuật của kết nối socket.
  Stream<RealtimeConnectionStatus> get statuses;

  // Mở socket booking; implementation sẽ quyết định dùng WebSocket cụ thể thế nào.
  Future<void> connectBookingSocket({
    required Uri uri,
    String? accessToken,
    bool parseInBackground,
  });

  // Đóng socket khi không cần nghe realtime nữa.
  Future<void> disconnect();
}

// Các trạng thái kết nối mà tầng presentation có thể dùng để log hoặc hiển thị.
enum RealtimeConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}
