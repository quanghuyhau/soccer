import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:soccer/utilities/utils/json_isolate_parser.dart';
import 'package:soccer/data/models/response/realtime_socket_event_response.dart';

enum RealtimeSocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

@lazySingleton
class RealtimeSocketDataSource {
  RealtimeSocketDataSource();

  // Stream này phát ra các event booking đã parse từ message WebSocket.
  final _events = StreamController<RealtimeSocketEventResponse>.broadcast();

  // Stream này phát ra trạng thái kết nối để UI/debug biết socket đang connect, reconnect hay lỗi.
  final _statuses = StreamController<RealtimeSocketStatus>.broadcast();

  // Kết nối WebSocket hiện tại; null nghĩa là chưa connect hoặc đã disconnect.
  WebSocket? _socket;

  // Subscription dùng để hủy listener cũ trước khi mở listener mới.
  StreamSubscription<dynamic>? _subscription;

  // Lưu lại URL socket để khi mất mạng có thể tự reconnect đúng endpoint cũ.
  Uri? _uri;

  // Lưu header Authorization để reconnect vẫn giữ token đăng nhập.
  Map<String, dynamic>? _headers;

  // true: parse JSON ở isolate phụ để tránh khựng UI khi socket trả message lớn.
  bool _parseInBackground = false;

  // Phân biệt app chủ động đóng socket với socket bị rớt do mạng/server.
  bool _closedByUser = false;

  // Đếm số lần reconnect để giới hạn retry và tăng thời gian chờ giữa mỗi lần.
  int _retryCount = 0;

  Stream<RealtimeSocketEventResponse> get events => _events.stream;
  Stream<RealtimeSocketStatus> get statuses => _statuses.stream;

  // Mở kết nối WebSocket tới backend và lưu lại thông tin để reconnect khi rớt mạng.
  Future<void> connect({
    required Uri uri,
    Map<String, dynamic>? headers,
    bool parseInBackground = false,
  }) async {
    debugPrint('Socket datasource connect requested: $uri');
    _uri = uri;
    _headers = headers;
    _parseInBackground = parseInBackground;
    _closedByUser = false;

    await _openSocket(RealtimeSocketStatus.connecting);
  }

  // Gửi một JSON message lên socket server nếu sau này app cần bắn event ngược lên backend.
  void sendJson(Map<String, dynamic> data) {
    _socket?.add(jsonEncode(data));
  }

  // Đóng kết nối do app chủ động, ví dụ khi rời màn Owner hoặc logout.
  Future<void> disconnect() async {
    _closedByUser = true;
    await _subscription?.cancel();
    await _socket?.close();
    _subscription = null;
    _socket = null;
    _statuses.add(RealtimeSocketStatus.disconnected);
  }

  // Dọn tài nguyên StreamController khi provider bị dispose.
  Future<void> dispose() async {
    await disconnect();
    await _events.close();
    await _statuses.close();
  }

  // Thực sự mở socket; nếu lỗi thì chuyển sang lịch reconnect.
  Future<void> _openSocket(RealtimeSocketStatus status) async {
    final uri = _uri;
    if (uri == null) {
      return;
    }

    _statuses.add(status);
    debugPrint('Socket status: $status -> $uri');

    try {
      // Trước khi mở socket mới, đóng listener/socket cũ để tránh nhận trùng event.
      await _subscription?.cancel();
      await _socket?.close();

      // Đây là dòng thực sự bắt tay WebSocket với backend.
      _socket = await WebSocket.connect(uri.toString(), headers: _headers);
      _retryCount = 0;
      _statuses.add(RealtimeSocketStatus.connected);
      debugPrint('Socket connected: $uri');

      // Mỗi message backend push xuống sẽ đi vào _handleMessage để parse thành event.
      _subscription = _socket?.listen(
        _handleMessage,
        onError: (error) {
          debugPrint('Socket listen error: $error');
          _handleDisconnected();
        },
        onDone: _handleDisconnected,
        cancelOnError: true,
      );
    } catch (error) {
      debugPrint('Socket connect error: $error');
      _statuses.add(RealtimeSocketStatus.error);
      _scheduleReconnect();
    }
  }

  // Nhận raw message từ backend, parse JSON rồi phát ra stream events cho controller nghe.
  Future<void> _handleMessage(dynamic rawMessage) async {
    if (rawMessage is! String) {
      debugPrint('Socket ignored non-string message: $rawMessage');
      return;
    }

    debugPrint('Socket raw message: $rawMessage');

    try {
      // Nếu bật isolate thì JSON được decode ở luồng phụ; nếu không thì decode ngay tại đây.
      final json = _parseInBackground
          ? await decodeJsonObjectInIsolate(rawMessage)
          : jsonDecode(rawMessage) as Map<String, dynamic>;

      // Sau khi parse xong, bắn event ra stream để repository/usecase/cubit phía trên nhận.
      _events.add(RealtimeSocketEventResponse.fromJson(json));
    } catch (error) {
      debugPrint('Socket parse error: $error');
      _statuses.add(RealtimeSocketStatus.error);
    }
  }

  // Xử lý khi socket bị ngắt: nếu không phải app tự đóng thì tự reconnect.
  void _handleDisconnected() {
    debugPrint('Socket disconnected');
    if (_closedByUser) {
      _statuses.add(RealtimeSocketStatus.disconnected);
      return;
    }

    _scheduleReconnect();
  }

  // Hẹn reconnect tối đa 5 lần, mỗi lần sau chờ lâu hơn một chút.
  void _scheduleReconnect() {
    if (_closedByUser || _retryCount >= 5) {
      return;
    }

    _retryCount++;
    debugPrint('Socket reconnect scheduled: attempt $_retryCount');

    // Chờ tăng dần: lần 1 chờ 2s, lần 2 chờ 4s... để server có thời gian phục hồi.
    Future<void>.delayed(Duration(seconds: _retryCount * 2), () {
      if (!_closedByUser) {
        _openSocket(RealtimeSocketStatus.reconnecting);
      }
    });
  }
}
