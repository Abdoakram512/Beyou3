import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> getProfile() async {
    if (await AuthHelper.isGuest()) {
      emit(ProfileGuest());
      return;
    }
    emit(ProfileLoading());
    final result = await repository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  void updateLocalProfile(dynamic user) {
    emit(ProfileLoaded(user));
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    final result = await repository.deleteAccount();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileDeleteAccountSuccess()), 
    );
  }
}
