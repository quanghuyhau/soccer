import 'package:atm_soundbox/data/data_source/local/pref/shared_preferences_manager.dart';
import 'package:atm_soundbox/utilities/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocalStorage {
  final SharedPreferencesManager preferences;
  final FlutterSecureStorage secureStorage;

  LocalStorage({
    required this.preferences,
    required this.secureStorage,
  });

  Future saveUserName(String? userName) async {
    await preferences.putString(keyUserName, userName ?? '');
  }

  String? getUserName() => preferences.getString(keyUserName);

  Future savePassword(String? password) async {
    await secureStorage.write(key: keyPassword, value: password);
  }

  Future<String?> getPassword() => secureStorage.read(key: keyPassword);

  Future saveToken(String? token) async {
    await preferences.putString(keyAccessToken, token ?? '');
  }

  String? getAccessToken() => preferences.getString(keyAccessToken);

  logout() {
    preferences.remove(keyAccessToken);
  }
}
