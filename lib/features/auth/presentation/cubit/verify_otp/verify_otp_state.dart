import '../../../../auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final UserModel user;

  const VerifyOtpSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class VerifyOtpError extends VerifyOtpState {
  final String message;

  const VerifyOtpError({required this.message});

  @override
  List<Object?> get props => [message];
}
