import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class PersonalDataState extends Equatable {
  const PersonalDataState();
  @override
  List<Object?> get props => [];
}

class PersonalDataInitial extends PersonalDataState {}

class PersonalDataLoading extends PersonalDataState {}

class PersonalDataSuccess extends PersonalDataState {
  final ProfileModel user;
  const PersonalDataSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class PersonalDataError extends PersonalDataState {
  final String message;
  const PersonalDataError(this.message);
  @override
  List<Object?> get props => [message];
}

class PersonalDataCubit extends Cubit<PersonalDataState> {
  final ProfileRepository repository;

  PersonalDataCubit({required this.repository}) : super(PersonalDataInitial());

  Future<void> updateProfile({required String name, String? imagePath}) async {
    emit(PersonalDataLoading());

    final Map<String, dynamic> data = {'name': name};
    if (imagePath != null) {
      data['image'] = imagePath; // DataSource will handle FormData if needed
    }

    final result = await repository.updateProfile(data);
    result.fold(
      (failure) => emit(PersonalDataError(failure.message)),
      (user) => emit(PersonalDataSuccess(user)),
    );
  }
}
