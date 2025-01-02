class DiagnosisResponse {
  final String diagnosis;

  DiagnosisResponse({required this.diagnosis});

  factory DiagnosisResponse.fromJson(Map<String, dynamic> json) {
    return DiagnosisResponse(
      diagnosis: json['diagnosis'] as String,
    );
  }
}
