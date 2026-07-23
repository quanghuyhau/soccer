class AppConfig {
  const AppConfig({required this.baseUrl});

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      baseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://192.168.102.51:8090',
      ),
    );
  }

  final String baseUrl;

  // Tạo URL socket từ baseUrl API: http -> ws, https -> wss, giữ nguyên host/port.
  Uri socketUri(String path) {
    final uri = Uri.parse(baseUrl);
    final socketScheme = uri.scheme == 'https' ? 'wss' : 'ws';

    return uri.replace(scheme: socketScheme, path: path);
  }
}
