import 'package:app/features/auth/domain/entities/app_patient.dart';

abstract class AuthStates {}

class AuthIntial extends AuthStates {}

class AuthLoading extends AuthStates {}

class Authenticated extends AuthStates {
  final AppUser patient;
  Authenticated(this.patient);
}

class UnAuthenticated extends AuthStates {}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
