import 'package:app/features/auth/domain/entities/app_patient.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Future<AppPatient?> loginWithEmailPassowrd(
      String email, String password) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {}
    // TODO: implement loginWithEmailPassowrd
    throw UnimplementedError();
  }

  @override
  Future<AppPatient?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, DateTime dateOfBirth) {
    // TODO: implement registerWithEmailPassowrd
    throw UnimplementedError();
  }

  @override
  Future<AppPatient?> getCurrentPatient() {
    // TODO: implement getCurrentPatient
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
