import 'package:app/features/patient/auth/domain/entities/app_patient.dart';

abstract class AuthStates {}

class AuthIntial extends AuthStates {}

class AuthLoading extends AuthStates {}


class Authenticated extends AuthStates {
  final AppPatient patient;
  Authenticated(this.patient);
}

class UnAuthenticated extends AuthStates {}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
