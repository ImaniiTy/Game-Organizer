import 'package:localstorage/localstorage.dart' as storage;

enum Collections { cookies, games }

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  final storage.LocalStorage localStorage = storage.LocalStorage('localStorage.json', "./local");

  Future<void> init() async {
    await localStorage.ready;
  }

  dynamic getItem(String key) {
    return localStorage.getItem(key);
  }

  Future<void> setItem(
    String key,
    dynamic value, [
    Object Function(Object)? toEncodable,
  ]) async {
    await localStorage.setItem(key, value, toEncodable);
  }
}
