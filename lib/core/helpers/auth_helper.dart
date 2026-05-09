import '../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../config/dependency_injection/di.dart';

class AuthHelper {
  static Future<bool> isLoggedIn() async {
    final token = await getIt<AuthLocalDataSource>().getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> isGuest() async {
    return !(await isLoggedIn());
  }

  static Future<String?> getToken() async {
    return await getIt<AuthLocalDataSource>().getToken();
  }

  // Uses try/finally so local cleanup always happens even if the server is unreachable.
  static Future<void> logout() async {
    try {
      if (await isLoggedIn()) {
        await getIt<AuthRemoteDataSource>().logout();
      }
    } catch (_) {
      // Server may be unreachable — proceed with local logout regardless
    } finally {
      await getIt<AuthLocalDataSource>().clearToken();
    }
  }
}
