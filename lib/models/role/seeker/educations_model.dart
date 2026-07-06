class EducationsModel {
  String? id;
  String? schoolName;
  String? degree;
  String? fieldOfStudy;
  String? startDate;
  String? endDate;

  EducationsModel({
    this.id,
    this.schoolName,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
  });

  factory EducationsModel.fromJson(Map<String, dynamic> json) {
    return EducationsModel(
      id: json['id'] as String?,
      schoolName: json['school_name'] as String?,
      degree: json['degree'] as String?,
      fieldOfStudy: json['field_of_study'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_name': schoolName,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
