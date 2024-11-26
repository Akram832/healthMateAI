import 'package:intl/intl.dart';

class AppUser {
  final int uId;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth; // Date-only field for date of birth

  AppUser({
    required this.uId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
  });

  // Convert AppPatient to JSON format
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,

      'dateOfBirth':
          DateFormat('yyyy-MM-dd').format(dateOfBirth), // Date-only format
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uId: jsonUser['uId'],
      email: jsonUser['email'],
      firstName: jsonUser['firstName'],
      lastName: jsonUser['lastName'],
      gender: jsonUser['gender'],
      dateOfBirth:
          DateTime.parse(jsonUser['dateOfBirth']), // Parse date-only string
    );
  }
}
