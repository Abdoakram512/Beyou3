import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'app_info_state.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  final ProfileRepository repository;

  AppInfoCubit(this.repository) : super(AppInfoInitial());

  Future<void> getAboutUs() async {
    emit(AppInfoLoading());
    final result = await repository.getAboutUs();
    result.fold(
      (failure) => emit(AppInfoError(failure.message)),
      (data) => emit(AppInfoLoaded(data)),
    );
  }

  Future<void> getPrivacyPolicy() async {
    emit(AppInfoLoading());
    final result = await repository.getPrivacyPolicy();
    result.fold(
      (failure) => emit(AppInfoError(failure.message)),
      (data) => emit(AppInfoLoaded(data)),
    );
  }

  Future<void> getTerms() async {
    emit(AppInfoLoading());
    final result = await repository.getTerms();
    result.fold(
      (failure) => emit(AppInfoError(failure.message)),
      (data) => emit(AppInfoLoaded(data)),
    );
  }

  Future<void> getFaqs() async {
    emit(AppInfoLoading());
    final result = await repository.getFaqs();
    result.fold(
      (failure) => emit(AppInfoError(failure.message)),
      (faqs) => emit(FaqLoaded(faqs)),
    );
  }
}
