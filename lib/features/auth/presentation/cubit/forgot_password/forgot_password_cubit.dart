import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordCubit({required this.authRepository})
    : super(ForgotPasswordInitial());

  Future<void> resetPassword(String phone) async {
    emit(ForgotPasswordLoading());
    final result = await authRepository.forgotPassword(phone: phone);

    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }
}
