import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import '../config/env.dart';

class AIChatService {
  Future<String> getDetailedExplanation(String diagnosis) async {
    if (Environment.geminiApiKey == 'AIzaSyDgeY8CUsrFPUPsPRJdOwZ3GLbXgb8AqAA') {
      throw Exception('Please set your Gemini API key in lib/config/env.dart');
    }

    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Explain the medical condition "$diagnosis" in simple terms and provide basic advice. Keep it concise.'
              }
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(
            '${ApiConstants.geminiApiEndpoint}?key=${Environment.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return _extractResponseText(result);
      } else {
        final error = await _handleApiError(response);
        throw error;
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to get AI explanation: $e');
    }
  }

  String _extractResponseText(Map<String, dynamic> result) {
    try {
      final candidates = result['candidates'] as List;
      if (candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }
      return candidates[0]['content']['parts'][0]['text'] as String;
    } catch (e) {
      throw Exception('Invalid response format from Gemini API');
    }
  }

  Exception _handleApiError(http.Response response) {
    try {
      final errorBody = jsonDecode(response.body);
      final error = errorBody['error'];
      final message = error?['message'] ?? 'Unknown error';
      final code = error?['code'] ?? 'Unknown code';
      return Exception('Gemini API error (${code}): ${message}');
    } catch (e) {
      return Exception(
          'Invalid error response from Gemini API: ${response.body}');
    }
  }
}
