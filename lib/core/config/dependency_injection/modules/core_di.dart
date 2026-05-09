import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import '../../../api/api_consumer.dart';
import '../../../api/dio_consumer.dart';
import '../../../api/end_points.dart';
import '../../../helpers/secure_storage_helper.dart';
import '../../../services/image_picker_service.dart';
import '../../../services/notification_service.dart';


Future<void> initCoreDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  // Secure Storage
  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton(() => secureStorage);
  getIt.registerLazySingleton(() => SecureStorageHelper(getIt()));

  // Cache Store setup
  final dir = await getTemporaryDirectory();
  final cacheStore = HiveCacheStore(
    dir.path,
    hiveBoxName: "beyou3_api_cache",
  );
  getIt.registerLazySingleton(() => cacheStore);

  final cacheOptions = CacheOptions(
    store: cacheStore,
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );
  getIt.registerLazySingleton(() => cacheOptions);

  // Dio & API Consumer
  final dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

  getIt.registerLazySingleton(() => dio);

  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt()));

  // Services
  getIt.registerLazySingleton(() => ImagePickerService());
  getIt.registerLazySingleton(() => NotificationService());
}
