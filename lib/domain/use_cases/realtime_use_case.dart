import 'package:injectable/injectable.dart';

import 'package:soccer/domain/entities/realtime_event.dart';
import 'package:soccer/domain/repositories/realtime_repository.dart';

@lazySingleton
class RealtimeUseCase {
  const RealtimeUseCase(this._repository);

  // UseCase chỉ phụ thuộc contract repository, không phụ thuộc WebSocket/Dio cụ thể.
  final RealtimeRepository _repository;

  // Stream event booking cho Cubit nghe và tự cập nhật UI khi backend push event.
  Stream<RealtimeEvent> get bookingEvents => _repository.events;

  // Stream trạng thái kết nối, dùng khi muốn hiển thị/debug socket connected/reconnecting.
  Stream<RealtimeConnectionStatus> get statuses => _repository.statuses;

  // UseCase mở socket booking và bật parse JSON bằng isolate để parse message không ảnh hưởng UI.
  Future<void> connectBookingSocket({required Uri uri, String? accessToken}) {
    return _repository.connectBookingSocket(
      uri: uri,
      accessToken: accessToken,
      parseInBackground: true,
    );
  }

  // UseCase đóng socket khi rời màn hoặc không cần realtime nữa.
  Future<void> disconnect() {
    return _repository.disconnect();
  }
}
