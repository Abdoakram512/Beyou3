import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import '../../../../../core/services/notification_service.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository authRepository;
  final NotificationService notificationService;

  static const int resendDelay = 60;
  Timer? _timer;
  int _secondsRemaining = resendDelay;

  OtpCubit({required this.authRepository, required this.notificationService})
    : super(OtpInitial()) {
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = resendDelay;
    _timer?.cancel();
    emit(OtpTimerUpdate(_secondsRemaining));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        emit(OtpTimerUpdate(_secondsRemaining));
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    String? fcmToken,
  }) async {
    emit(OtpVerifyLoading());

    final token =
        fcmToken ?? await notificationService.getToken() ?? 'no_token';

    final result = await authRepository.verifyOtpUser(
      phone: phone,
      otp: otp,
      fcmToken: token,
    );

    result.fold(
      (failure) => emit(OtpVerifyFailure(failure.message)),
      (_) => emit(OtpVerifySuccess()),
    );
  }

  Future<void> resendOtp(String phone) async {
    if (_secondsRemaining > 0) return;

    emit(OtpResendLoading());
    final result = await authRepository.resendOtp(phone: phone);

    result.fold((failure) => emit(OtpResendFailure(failure.message)), (_) {
      emit(OtpResendSuccess());
      _startTimer();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
