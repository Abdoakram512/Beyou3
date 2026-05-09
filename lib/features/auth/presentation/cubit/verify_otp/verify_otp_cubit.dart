import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import '../../../../../core/services/notification_service.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository authRepository;
  final NotificationService notificationService;

  VerifyOtpCubit({
    required this.authRepository,
    required this.notificationService,
  }) : super(VerifyOtpInitial());

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    String? fcmToken,
  }) async {
    emit(VerifyOtpLoading());

    // Automatically get token if not provided
    final token =
        fcmToken ?? await notificationService.getToken() ?? 'no_token';

    final result = await authRepository.verifyOtpUser(
      phone: phone,
      otp: otp,
      fcmToken: token,
    );

    result.fold(
      (failure) => emit(VerifyOtpError(message: failure.message)),
      (user) => emit(VerifyOtpSuccess(user: user)),
    );
  }
}
