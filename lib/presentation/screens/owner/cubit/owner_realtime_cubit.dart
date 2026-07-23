import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/data/data_source/services/app_endpoints.dart';
import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/domain/entities/app_models.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/presentation/screens/owner/cubit/owner_dashboard_cubit.dart';
import 'package:soccer/presentation/screens/owner/state/owner_realtime_state.dart';

class OwnerRealtimeCubit extends Cubit<OwnerRealtimeState> {
  // Khi màn Owner tạo Cubit này, socket sẽ tự connect để owner nhận booking realtime.
  OwnerRealtimeCubit({
    required AppUseCase useCase,
    required AppConfig config,
    required AppSessionCubit sessionCubit,
    required OwnerDashboardCubit dashboardCubit,
  }) : _useCase = useCase,
       _config = config,
       _sessionCubit = sessionCubit,
       _dashboardCubit = dashboardCubit,
       super(const OwnerRealtimeInitial()) {
    connect();
  }

  // UseCase là cổng đi xuống domain để mở socket, nghe event và disconnect.
  final AppUseCase _useCase;

  // AppConfig chuyển baseUrl HTTP sang URL WebSocket đúng môi trường đang chạy.
  final AppConfig _config;

  // Session giữ token hiện tại; socket cần token để backend xác thực owner.
  final AppSessionCubit _sessionCubit;

  // Dashboard cubit được reload khi socket báo có booking mới/cập nhật/hủy.
  final OwnerDashboardCubit _dashboardCubit;

  // Listener event socket; cần giữ lại để hủy khi Cubit dispose.
  StreamSubscription<RealtimeEvent>? _subscription;

  // Kết nối socket booking cho owner để nhận sự kiện realtime từ backend.
  Future<void> connect() async {
    emit(const OwnerRealtimeConnecting());
    try {
      debugPrint('Owner realtime cubit started');

      // Lấy token từ session, tương tự lúc call API có header Authorization.
      final session = _sessionCubit.state;
      final token = session?.tokens.accessToken;

      if (session == null || token == null || token.isEmpty) {
        debugPrint('Owner realtime skipped: missing session/token');
        return;
      }

      // Tạo URL ws/wss từ baseUrl, ví dụ http://host:8090 -> ws://host:8090/ws/bookings.
      final uri = _config.socketUri(AppEndpoints.bookingSocket);
      debugPrint('Socket connecting: $uri');

      // Nhờ usecase mở socket; controller không biết chi tiết WebSocket nằm ở data source.
      await _useCase.realtime.connectBookingSocket(
        uri: uri,
        accessToken: token,
      );
      debugPrint('Owner realtime connected');

      await _subscription?.cancel();

      // Lắng nghe event realtime; khi có booking event thì reload dữ liệu quản lý.
      _subscription = _useCase.realtime.bookingEvents.listen((event) {
        debugPrint('Socket event: ${event.type} ${event.data}');
        if (event.isBookingEvent) {
          // Không await để UI không bị chặn; dashboard tự cập nhật khi load xong.
          unawaited(_dashboardCubit.load());
        }
      });
      emit(const OwnerRealtimeConnected());
    } catch (error, stackTrace) {
      emit(OwnerRealtimeFailure.from(error, stackTrace));
    }
  }

  // Đóng socket/listener khi Cubit bị dispose để tránh giữ kết nối cũ.
  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _useCase.realtime.disconnect();
    return super.close();
  }
}
