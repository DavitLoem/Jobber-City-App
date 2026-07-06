class TraningsModel {
  String? courseName;
  String? institution;
  String? startDate;
  String? endDate;
  String? description;
  String? certificateUrl;

  TraningsModel({
    this.courseName,
    this.institution,
    this.startDate,
    this.endDate,
    this.description,
    this.certificateUrl,
  });

  factory TraningsModel.fromJson(Map<String, dynamic> json) {
    return TraningsModel(
      courseName: json['course_name'] as String?,
      institution: json['institution'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      description: json['description'] as String?,
      certificateUrl: json['certificate_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_name': courseName,
      'institution': institution,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
      'certificate_url': certificateUrl,
    };
  }
}
