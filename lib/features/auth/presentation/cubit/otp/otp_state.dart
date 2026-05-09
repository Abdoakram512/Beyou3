import 'package:flutter/foundation.dart';

@immutable
sealed class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifyLoading extends OtpState {}

class OtpVerifySuccess extends OtpState {}

class OtpVerifyFailure extends OtpState {
  final String message;
  OtpVerifyFailure(this.message);
}

class OtpResendLoading extends OtpState {}

class OtpResendSuccess extends OtpState {}

class OtpResendFailure extends OtpState {
  final String message;
  OtpResendFailure(this.message);
}

class OtpTimerUpdate extends OtpState {
  final int secondsRemaining;
  OtpTimerUpdate(this.secondsRemaining);
}
