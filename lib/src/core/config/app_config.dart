import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(
    baseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://192.168.102.123:8090',
    ),
  );
});

class AppConfig {
  const AppConfig({required this.baseUrl});

  final String baseUrl;
}
