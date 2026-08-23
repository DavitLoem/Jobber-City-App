/// Mirrors `CVTemplateInfo` in `cv_schema.py` — one selectable option on the
/// CV Generator's template picker.
class CvTemplateModel {
  final String id;
  final String name;
  final String description;

  CvTemplateModel({required this.id, required this.name, required this.description});

  factory CvTemplateModel.fromJson(Map<String, dynamic> json) => CvTemplateModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
      );
}

/// Mirrors `CurrentCVResponse` — the most recently generated CV (if any),
/// shown at the top of the CV Generator screen so the seeker doesn't lose
/// track of what they already made.
class CurrentCvModel {
  final String? cvUrl;
  final String? templateId;
  final DateTime? generatedAt;

  CurrentCvModel({this.cvUrl, this.templateId, this.generatedAt});

  bool get hasCv => cvUrl != null && cvUrl!.isNotEmpty;

  factory CurrentCvModel.fromJson(Map<String, dynamic> json) => CurrentCvModel(
        cvUrl: json['cv_url'],
        templateId: json['template_id'],
        generatedAt: json['generated_at'] != null ? DateTime.tryParse(json['generated_at'].toString()) : null,
      );
}

/// Mirrors `GenerateCVResponse` — the result of a successful `/generate` call.
class GeneratedCvModel {
  final String cvUrl;
  final String templateId;
  final DateTime generatedAt;

  GeneratedCvModel({required this.cvUrl, required this.templateId, required this.generatedAt});

  factory GeneratedCvModel.fromJson(Map<String, dynamic> json) => GeneratedCvModel(
        cvUrl: json['cv_url'] ?? '',
        templateId: json['template_id'] ?? '',
        generatedAt: DateTime.tryParse(json['generated_at']?.toString() ?? '') ?? DateTime.now(),
      );
}
