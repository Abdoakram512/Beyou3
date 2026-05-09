import 'package:get_it/get_it.dart';
import '../../../../features/categories/data/datasources/category_remote_data_source.dart';
import '../../../../features/categories/data/repositories/category_repository_impl.dart';
import '../../../../features/categories/domain/repositories/category_repository.dart';
import '../../../../features/categories/presentation/cubit/categories_cubit.dart';


Future<void> initCategoriesDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerFactory(() => CategoriesCubit(repository: getIt()));
}
