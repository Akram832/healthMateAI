import 'package:app/features/auth/domain/entities/app_patient.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailPassowrd(String email, String password) async {
    try {
      // Attempt sign-in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found in Firestore');
      }

      return AppUser(
        uId: userCredential.user!.uid,
        email: email,
        firstName: userDoc['firstName'],
        lastName: userDoc['lastName'],
        gender: userDoc['gender'],
        dateOfBirth: DateTime.parse(userDoc['dateOfBirth']),
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassowrd(String email, String password,
      String lastName, String firstName, DateTime dateOfBirth) async {
    try {
      // Create user in FirebaseAuth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': '', // Add gender as needed
      });

      return AppUser(
        uId: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        gender: '',
        dateOfBirth: dateOfBirth,
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    // Retrieve user data from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User data not found');
    }

    return AppUser(
      uId: firebaseUser.uid,
      email: firebaseUser.email!,
      firstName: userDoc['firstName'],
      lastName: userDoc['lastName'],
      gender: userDoc['gender'],
      dateOfBirth: DateTime.parse(userDoc['dateOfBirth']),
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
  }

  @override
  Future<AppUser?> loginWithGoogleAuth() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      // Optionally, fetch additional user data from Firestore if needed
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // If the user doesn't exist in Firestore, create their profile
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': userCredential.user!.email,
          'firstName': '', // Add fields as necessary
          'lastName': '',
          'dateOfBirth': '', // Placeholder; replace as needed
        });
      }

      return AppUser(
        uId: userCredential.user!.uid,
        email: userCredential.user!.email!,
        firstName: userDoc.data()?['firstName'] ?? '',
        lastName: userDoc.data()?['lastName'] ?? '',
        dateOfBirth: userDoc.data()?['dateOfBirth'] != null
            ? DateTime.parse(userDoc.data()!['dateOfBirth'])
            : DateTime.now(),
        gender: userDoc.data()?['gender'] ?? '',
      );
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
