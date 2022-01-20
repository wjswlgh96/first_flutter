import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = const FlutterSecureStorage();

  Future<String> getStoredValue(String key) async {
    try {
      String? value = await storage.read(key: key);

      return value!;
    } catch (error) {
      print('error: $error');

      return '$error';
    }
  }

  Future<void> storeValue(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } catch (error) {
      print('error: $error');
      return;
    }
  }
}
