import 'package:get_it/get_it.dart';
import '../../../../features/create_ad/presentation/cubit/create_ad_cubit.dart';
import '../../../../features/create_ad/presentation/cubit/ad_category_selection_cubit.dart';
import '../../../../features/create_ad/data/datasources/ad_remote_data_source.dart';
import '../../../../features/create_ad/data/datasources/brands_remote_data_source.dart';
import '../../../../features/create_ad/domain/repositories/ad_repository.dart';
import '../../../../features/create_ad/data/repositories/ad_repository_impl.dart';

Future<void> initCreateAdDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<AdRemoteDataSource>(
    () => AdRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<BrandsRemoteDataSource>(
    () => BrandsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AdRepository>(
    () => AdRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory(() => CreateAdCubit(getIt()));
  getIt.registerFactory(() => AdCategorySelectionCubit(getIt(), getIt()));
}
