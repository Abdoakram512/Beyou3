import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import 'package:beyou3/core/services/notification_service.dart';
import '../../../../../core/error/failures.dart';
import '../auth_status/auth_status_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final AuthStatusCubit authStatusCubit;
  final NotificationService notificationService;

  LoginCubit({
    required this.authRepository,
    required this.authStatusCubit,
    required this.notificationService,
  }) : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoading());
    try {
      final fcmToken = await notificationService.getToken();
      final result = await authRepository.login(
        phone: phone,
        password: password,
        fcmToken: fcmToken ?? '',
      );

      result.fold(
        (failure) {
          if (failure is ServerFailure && failure.code == 415) {
            final phoneFromData = failure.data?['phone']?.toString();
            emit(LoginUnverified(phoneFromData ?? phone));
          } else {
            emit(LoginFailure(failure.message));
          }
        },
        (user) {
          if (user.token.isNotEmpty) {
            authStatusCubit.loggedIn();
            emit(LoginSuccess());
          } else {
            emit(
              LoginFailure(
                'Failed to retrieve authentication token from server',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
