import 'package:app/features/auth/domain/entities/app_patient.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Future<AppUser?> loginWithEmailPassowrd(
      String email, String password) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
          uId: userCredential.user!.uid, email: email, firstName: '', lastName: '', gender: '', dateOfBirth: DateTime(1970, 1, 1));

      return user;
    } catch (e) {
      throw Exception('login failed$e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, DateTime dateOfBirth) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
          uId: userCredential.user!.uid, email: email, firstName: firstName, lastName: '', gender: '', dateOfBirth: DateTime(1970, 1, 1));

      return user;
    } catch (e) {
      throw Exception('register failed$e');
    }
  }

  Future<AppUser?> getCurrentPatient() async {
    // get person logged in from firebase
    final firebaseUser = firebaseAuth.currentUser;
    // no user logged in
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(
        uId: firebaseUser.uid, email: firebaseUser.email!, firstName: '', lastName: '', gender: '', dateOfBirth: DateTime(1970, 1, 1));
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
