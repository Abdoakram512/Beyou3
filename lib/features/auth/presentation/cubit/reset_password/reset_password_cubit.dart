import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordCubit({required this.authRepository})
    : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.resetPassword(
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failure) => emit(ResetPasswordFailure(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}
