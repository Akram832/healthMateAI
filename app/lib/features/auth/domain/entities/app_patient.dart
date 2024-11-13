import 'package:intl/intl.dart';

class AppPatient {
  final int uId;
  final String email;
  final String firstName;
  /*final String lastName;
  final DateTime dateOfBirth; // Date-only field for date of birth*/

  AppPatient({
    required this.uId,
    required this.email,
    required this.firstName,
    /*required this.lastName,
    required this.dateOfBirth,*/
  });

  // Convert AppPatient to JSON format
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'firstName': firstName,
      /*'lastName': lastName,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth), // Date-only format*/
    };
  }

  factory AppPatient.fromJson(Map<String, dynamic> jsonUser) {
    return AppPatient(
      uId: jsonUser['uId'],
      email: jsonUser['email'],
      firstName: jsonUser['firstName'],
      /*lastName: jsonUser['lastName'],
      dateOfBirth: DateTime.parse(jsonUser['dateOfBirth']), // Parse date-only string*/
    );
  }
}