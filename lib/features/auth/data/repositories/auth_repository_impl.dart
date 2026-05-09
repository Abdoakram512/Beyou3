import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/api/error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    return safeCall(() async {
      final user = await remoteDataSource.login(
        phone: phone,
        password: password,
        fcmToken: fcmToken,
      );
      await localDataSource.saveToken(user.token);
      return user;
    });
  }

  @override
  Future<Either<Failure, String>> registerUser({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    return safeCall(
      () => remoteDataSource.register(
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> verifyOtpUser({
    required String phone,
    required String otp,
    required String fcmToken,
  }) async {
    return safeCall(() async {
      final user = await remoteDataSource.verifyOtp(
        phone: phone,
        token: otp,
        fcmToken: fcmToken,
      );
      await localDataSource.saveToken(user.token);
      return user;
    });
  }

  @override
  Future<Either<Failure, void>> resendOtp({required String phone}) async {
    return safeCall(() => remoteDataSource.resendOtp(phone: phone));
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String phone}) async {
    return safeCall(() => remoteDataSource.forgotPassword(phone: phone));
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    return safeCall(
      () => remoteDataSource.resetPassword(
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return safeCall(() async {
      try {
        await remoteDataSource.logout();
      } catch (_) {
        // Ignore network error on logout
      } finally {
        await localDataSource.clearToken();
      }
    });
  }
}
