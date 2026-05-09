import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();
  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final String message;
  const ContactUsSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ContactUsError extends ContactUsState {
  final String message;
  const ContactUsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ContactUsCubit extends Cubit<ContactUsState> {
  final ProfileRepository repository;

  ContactUsCubit({required this.repository}) : super(ContactUsInitial());

  Future<void> sendContactMessage({
    required String subject,
    required String message,
  }) async {
    emit(ContactUsLoading());
    final result = await repository.sendContactMessage(
      subject: subject,
      message: message,
    );
    result.fold(
      (failure) => emit(ContactUsError(failure.message)),
      (_) => emit(const ContactUsSuccess('Message Sent Successfully')),
    );
  }
}
