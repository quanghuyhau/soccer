import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider = Provider<AuthTokenProvider>((ref) {
  return const AuthTokenProvider();
});

class AuthTokenProvider {
  const AuthTokenProvider();

  Future<String?> getToken() async {
    // Connect secure storage or your auth state here.
    return null;
  }
}
