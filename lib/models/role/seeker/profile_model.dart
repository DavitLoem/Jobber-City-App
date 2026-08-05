class ExperienceModel {
  String? id;
  String jobTitle;
  String companyName;
  String? startDate;
  String? endDate;
  bool isCurrentJob;
  String? description;

  ExperienceModel({
    this.id,
    required this.jobTitle,
    required this.companyName,
    this.startDate,
    this.endDate,
    this.isCurrentJob = false,
    this.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['_id'] ?? json['id'],
      jobTitle: json['job_title'] ?? '',
      companyName: json['company_name'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      isCurrentJob: json['is_current_job'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'company_name': companyName,
      'start_date': startDate,
      'end_date': endDate,
      'is_current_job': isCurrentJob,
      'description': description,
    };
  }
}

class EducationModel {
  String? id;
  String schoolName;
  String degree;
  String? fieldOfStudy;
  String? startDate;
  String? endDate;

  EducationModel({
    this.id,
    required this.schoolName,
    required this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['_id'] ?? json['id'],
      schoolName: json['school_name'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['field_of_study'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class TrainingModel {
  String? id;
  String courseName;
  String institution;
  String? startDate;
  String? endDate;
  String? description;
  String? certificateUrl;

  TrainingModel({
    this.id,
    required this.courseName,
    required this.institution,
    this.startDate,
    this.endDate,
    this.description,
    this.certificateUrl,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['_id'] ?? json['id'],
      courseName: json['course_name'] ?? '',
      institution: json['institution'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
      certificateUrl: json['certificate_url'],
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

class LanguageModel {
  String? id;
  String language;
  String proficiency;

  LanguageModel({this.id, required this.language, required this.proficiency});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['_id'] ?? json['id'],
      language: json['language'] ?? '',
      proficiency: json['proficiency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'language': language, 'proficiency': proficiency};
  }
}
