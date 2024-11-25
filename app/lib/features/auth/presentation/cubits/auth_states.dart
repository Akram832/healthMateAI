import 'package:app/features/auth/domain/entities/app_patient.dart';

abstract class AuthStates {}

abstract class SwitchEvent {}

class AuthIntial extends AuthStates {}

class AuthLoading extends AuthStates {}

class ToggleSwitchEvent extends SwitchEvent {}

class SwitchState {
  final bool isOn;
  SwitchState(this.isOn);
} 

class Authenticated extends AuthStates {
  final AppUser patient;
  Authenticated(this.patient);
}

class UnAuthenticated extends AuthStates {}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
