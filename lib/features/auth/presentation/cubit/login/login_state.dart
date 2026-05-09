import 'package:flutter/foundation.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginUnverified extends LoginState {
  final String phone;
  LoginUnverified(this.phone);
}
