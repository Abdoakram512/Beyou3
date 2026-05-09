import '../../../../core/helpers/secure_storage_helper.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'TOKEN_KEY';
  final SecureStorageHelper secureStorageHelper;

  AuthLocalDataSourceImpl({required this.secureStorageHelper});

  @override
  Future<void> saveToken(String token) async {
    await secureStorageHelper.writeData(key: _tokenKey, value: token);
  }

  @override
  Future<void> clearToken() async {
    await secureStorageHelper.deleteData(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorageHelper.readData(key: _tokenKey);
  }
}
