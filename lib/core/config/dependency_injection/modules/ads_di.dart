import 'package:get_it/get_it.dart';
import '../../../../features/ads/data/datasources/ads_remote_data_source.dart';
import '../../../../features/ads/data/repositories/ads_repository_impl.dart';
import '../../../../features/ads/domain/repositories/ads_repository.dart';
import '../../../../features/ads/presentation/cubit/featured_ads_cubit.dart';
import '../../../../features/ads/presentation/cubit/ads_list_cubit.dart';
import '../../../../features/ads/presentation/cubit/ad_details_cubit.dart';
import '../../../../features/ads/presentation/cubit/my_ads_cubit.dart';


Future<void> initAdsDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<AdsRemoteDataSource>(
    () => AdsRemoteDataSourceImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerFactory(() => FeaturedAdsCubit(adsRepository: getIt()));
  getIt.registerFactory(() => AdsListCubit(adsRepository: getIt()));
  getIt.registerFactory(() => AdDetailsCubit(repository: getIt()));
  getIt.registerFactory(() => MyAdsCubit(adsRepository: getIt()));
}
