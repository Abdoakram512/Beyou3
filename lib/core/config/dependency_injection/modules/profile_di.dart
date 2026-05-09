import 'package:get_it/get_it.dart';
import '../../../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../../../features/profile/data/repositories/profile_repository.dart';
import '../../../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../../../features/profile/presentation/cubit/personal_data_cubit.dart';
import '../../../../features/profile/presentation/cubit/contact_us_cubit.dart';
import '../../../../features/profile/presentation/cubit/app_info_cubit.dart';


Future<void> initProfileDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepository(remoteDataSource: getIt(), localDataSource: getIt()),
  );
  getIt.registerFactory(() => ProfileCubit(repository: getIt()));
  getIt.registerFactory(() => PersonalDataCubit(repository: getIt()));
  getIt.registerFactory(() => ContactUsCubit(repository: getIt()));
  getIt.registerFactory(() => AppInfoCubit(getIt()));
}
