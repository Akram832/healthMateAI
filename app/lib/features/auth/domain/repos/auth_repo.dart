import 'package:app/features/auth/domain/entities/app_patient.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassowrd(String email, String password);
  Future<AppUser?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, int phoneNumber, DateTime dateOfBirth);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> loginWithGoogleAuth();
  Future<AppUser?> loginWithAppleAuth();
}
