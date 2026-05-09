import 'package:flutter/foundation.dart';

@immutable
sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  RegisterSuccess(this.message);
}

class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}

class RegisterUnverified extends RegisterState {
  final String phone;
  RegisterUnverified(this.phone);
}
