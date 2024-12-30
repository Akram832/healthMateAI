import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/diagnosis_response.dart';
import '../constants/api_constants.dart';

class MedicalClassifierService {
  Future<String> getDiagnosis(String symptoms) async {
    if (symptoms.trim().isEmpty) {
      throw Exception('Symptoms cannot be empty');
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': symptoms}),
      );

      if (response.statusCode == 200) {
        return DiagnosisResponse.fromJson(jsonDecode(response.body)).diagnosis;
      } else {
        throw Exception(
            jsonDecode(response.body)['detail'] ?? 'Failed to get diagnosis');
      }
    } catch (e) {
      throw Exception('Error connecting to medical classifier service: $e');
    }
  }
}
