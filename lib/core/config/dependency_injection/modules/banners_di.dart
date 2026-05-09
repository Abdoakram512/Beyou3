import 'package:get_it/get_it.dart';
import '../../../../features/banners/data/datasources/banner_remote_data_source.dart';
import '../../../../features/banners/data/repositories/banner_repository_impl.dart';
import '../../../../features/banners/domain/repositories/banner_repository.dart';
import '../../../../features/banners/presentation/cubit/banners_cubit.dart';


Future<void> initBannersDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerFactory(() => BannersCubit(repository: getIt()));
}
