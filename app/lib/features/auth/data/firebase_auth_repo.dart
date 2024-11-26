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
      AppPatient user = AppPatient(
          uId: userCredential.user!.uid, email: email, firstName: '');

      return user;
    } catch (e) {
      throw Exception('login failed$e');
    }
  }

  @override
  Future<AppPatient?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, DateTime dateOfBirth) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppPatient user = AppPatient(
          uId: userCredential.user!.uid, email: email, firstName: firstName);

      return user;
    } catch (e) {
      throw Exception('register failed$e');
    }
  }

  @override
  Future<AppPatient?> getCurrentPatient() async {
    // get person logged in from firebase
    final firebaseUser = firebaseAuth.currentUser;
    // no user logged in
    if (firebaseUser == null) {
      return null;
    }
    return AppPatient(
        uId: firebaseUser.uid, email: firebaseUser.email!, firstName: '');
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
