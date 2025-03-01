import 'package:app/features/auth/domain/entities/app_patient.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:app/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubits extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppPatient? _currentPatient;

  AuthCubits({required this.authRepo}) : super(AuthIntial());

  // check if patient is already authenticated
  void checkAuth() async {
    final AppPatient? patient = await authRepo.getCurrentPatient();
    if (patient != null) {
      _currentPatient = patient;
      emit(Authenticated(patient));
    } else {
      emit(UnAuthenticated());
    }
  }

  // get current patient
  AppPatient? get currentPatient => _currentPatient;
  // login with email
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final patient = await authRepo.loginWithEmailPassowrd(email, pw);
      if (patient != null) {
        _currentPatient = patient;
        emit(Authenticated(patient));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> resetpassword() async {}
  //register with email
  Future<void> register(String email, String pw, String lastName,
      String firstName, int phoneNumber, DateTime dateOfBirth) async {
    try {
      emit(AuthLoading());
      final patient = await authRepo.registerWithEmailPassowrd(
          email, pw, lastName, firstName, phoneNumber, dateOfBirth);
      if (patient != null) {
        _currentPatient = patient;
        emit(Authenticated(patient));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthenticated());
  }
}
