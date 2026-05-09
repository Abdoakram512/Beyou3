import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import '../../../../../core/error/failures.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(RegisterLoading());
    final result = await authRepository.registerUser(
      name: name,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold((failure) {
      if (failure is ServerFailure && failure.code == 415) {
        final phoneFromData = failure.data?['phone']?.toString();
        emit(RegisterUnverified(phoneFromData ?? phone));
      } else {
        emit(RegisterFailure(failure.message));
      }
    }, (message) => emit(RegisterSuccess(message)));
  }
}
