import 'package:injectable/injectable.dart';

import 'package:soccer/data/data_source/services/app_data_source.dart';
import 'package:soccer/domain/entities/realtime_event.dart';
import 'package:soccer/domain/repositories/realtime_repository.dart';

@LazySingleton(as: RealtimeRepository)
// Repository nối domain với data source: domain chỉ thấy RealtimeEvent, không thấy WebSocket.
class RealtimeRepositoryImpl implements RealtimeRepository {
  const RealtimeRepositoryImpl(this._dataSource);

  // Data source là lớp làm việc trực tiếp với WebSocket thật.
  final RealtimeSocketDataSource _dataSource;

  // Trả event đã parse lên domain/presentation.
  @override
  Stream<RealtimeEvent> get events => _dataSource.events;

  // Chuyển status từ data source sang status domain để tầng trên không phụ thuộc data source.
  @override
  Stream<RealtimeConnectionStatus> get statuses {
    return _dataSource.statuses.map(_mapStatus);
  }

  // Gắn token vào header rồi nhờ data source mở kết nối WebSocket.
  // Nếu backend cần xác thực socket, token này chính là Bearer token sau login.
  @override
  Future<void> connectBookingSocket({
    required Uri uri,
    String? accessToken,
    bool parseInBackground = false,
  }) {
    return _dataSource.connect(
      uri: uri,
      headers: accessToken == null || accessToken.isEmpty
          ? null
          : {'Authorization': 'Bearer $accessToken'},
      parseInBackground: parseInBackground,
    );
  }

  // Đóng kết nối socket qua data source.
  @override
  Future<void> disconnect() {
    return _dataSource.disconnect();
  }

  // Map enum nội bộ data source sang enum public của repository.
  RealtimeConnectionStatus _mapStatus(RealtimeSocketStatus status) {
    return switch (status) {
      RealtimeSocketStatus.disconnected =>
        RealtimeConnectionStatus.disconnected,
      RealtimeSocketStatus.connecting => RealtimeConnectionStatus.connecting,
      RealtimeSocketStatus.connected => RealtimeConnectionStatus.connected,
      RealtimeSocketStatus.reconnecting =>
        RealtimeConnectionStatus.reconnecting,
      RealtimeSocketStatus.error => RealtimeConnectionStatus.error,
    };
  }
}
