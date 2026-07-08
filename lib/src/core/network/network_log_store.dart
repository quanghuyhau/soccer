class NetworkLogStore {
  NetworkLogStore._();

  static final NetworkLogStore instance = NetworkLogStore._();

  final List<String> _logs = <String>[];

  List<String> get logs => List.unmodifiable(_logs);

  void add(String message) {
    _logs.add(message);

    if (_logs.length > 300) {
      _logs.removeRange(0, _logs.length - 300);
    }
  }

  void clear() {
    _logs.clear();
  }
}
