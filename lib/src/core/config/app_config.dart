import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(baseUrl: 'https://jsonplaceholder.typicode.com');
});

class AppConfig {
  const AppConfig({required this.baseUrl});

  final String baseUrl;
}
