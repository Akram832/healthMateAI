import 'package:app/features/auth/domain/entities/app_patient.dart';

abstract class AuthRepo {
  Future<AppPatient?> loginWithEmailPassowrd(String email, String password);
  Future<AppPatient?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, DateTime dateOfBirth);
  Future<void> logout();
  Future<AppPatient?> getCurrentPatient();
}
