import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage;

  SecureStorageHelper(this._secureStorage);

  Future<void> writeData({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readData({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
