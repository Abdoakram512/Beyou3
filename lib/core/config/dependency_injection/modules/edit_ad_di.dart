import 'package:beyou3/core/api/api_consumer.dart';

import '../di.dart';
import '../../../../features/edit_ad/data/datasources/edit_ad_remote_data_source.dart';
import '../../../../features/edit_ad/data/repositories/edit_ad_repository.dart';
import '../../../../features/edit_ad/presentation/cubit/edit_ad_cubit.dart';

Future<void> initEditAdDI() async {
  // Remote Data Source
  getIt.registerLazySingleton<EditAdRemoteDataSource>(
    () => EditAdRemoteDataSourceImpl(getIt<ApiConsumer>()),
  );

  // Repository
  getIt.registerLazySingleton<EditAdRepository>(
    () => EditAdRepository(getIt<EditAdRemoteDataSource>()),
  );

  // Cubit
  getIt.registerFactory<EditAdCubit>(
    () => EditAdCubit(getIt<EditAdRepository>()),
  );
}
