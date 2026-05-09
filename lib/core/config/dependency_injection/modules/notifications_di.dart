import 'package:get_it/get_it.dart';
import '../../../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../../../features/notifications/presentation/cubit/notifications_cubit.dart';


Future<void> initNotificationsDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  // Data Sources
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(apiConsumer: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: getIt()),
  );

  // Cubits
  getIt.registerFactory(() => NotificationsCubit(repository: getIt()));
}
