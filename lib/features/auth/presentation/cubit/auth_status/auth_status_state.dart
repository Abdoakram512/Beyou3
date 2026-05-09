import 'package:flutter/foundation.dart';

@immutable
sealed class AuthStatusState {}

class AuthStatusInitial extends AuthStatusState {}

class AuthStatusAuthenticated extends AuthStatusState {}

class AuthStatusUnauthenticated extends AuthStatusState {}
