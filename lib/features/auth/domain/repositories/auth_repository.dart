import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String phone,
    required String password,
    required String fcmToken,
  });

  Future<Either<Failure, String>> registerUser({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, UserModel>> verifyOtpUser({
    required String phone,
    required String otp,
    required String fcmToken,
  });

  Future<Either<Failure, void>> resendOtp({required String phone});

  Future<Either<Failure, void>> forgotPassword({required String phone});
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, void>> logout();
}
