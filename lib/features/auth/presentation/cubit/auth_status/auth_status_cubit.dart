import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import 'auth_status_state.dart';

class AuthStatusCubit extends Cubit<AuthStatusState> {
  final AuthLocalDataSource localDataSource;
  final AuthRepository authRepository;

  AuthStatusCubit({required this.localDataSource, required this.authRepository})
    : super(AuthStatusInitial());

  Future<void> checkAuthStatus() async {
    final token = await localDataSource.getToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthStatusAuthenticated());
    } else {
      emit(AuthStatusUnauthenticated());
    }
  }

  void loggedIn() {
    emit(AuthStatusAuthenticated());
  }

  Future<void> loggedOut() async {
    await authRepository.logout();
    emit(AuthStatusUnauthenticated());
  }
}
