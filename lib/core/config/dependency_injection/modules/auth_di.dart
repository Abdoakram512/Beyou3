import 'package:get_it/get_it.dart';
import '../../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../../features/auth/presentation/cubit/auth_status/auth_status_cubit.dart';
import '../../../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../../../features/auth/presentation/cubit/otp/otp_cubit.dart';
import '../../../../features/auth/presentation/cubit/register/register_cubit.dart';
import '../../../../features/auth/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import '../../../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';


Future<void> initAuthDI() async {
  // ✅ Fix 4.1: getIt scoped to function — no module-level redeclaration
  final getIt = GetIt.instance;
  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorageHelper: getIt()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // Cubits
  // ✅ Fix 4.4: Registered as Factory intentionally.
  // AuthStatusCubit is created exactly once at the app root via BlocProvider in MyApp,
  // which handles its disposal automatically on app exit.
  getIt.registerFactory(
    () => AuthStatusCubit(localDataSource: getIt(), authRepository: getIt()),
  );
  getIt.registerFactory(
    () => LoginCubit(
      authRepository: getIt(),
      authStatusCubit: getIt(),
      notificationService: getIt(),
    ),
  );
  getIt.registerFactory(() => RegisterCubit(authRepository: getIt()));
  getIt.registerFactory(
    () => VerifyOtpCubit(authRepository: getIt(), notificationService: getIt()),
  );
  getIt.registerFactory(
    () => OtpCubit(authRepository: getIt(), notificationService: getIt()),
  );
  getIt.registerFactory(() => ForgotPasswordCubit(authRepository: getIt()));
  getIt.registerFactory(() => ResetPasswordCubit(authRepository: getIt()));
}
