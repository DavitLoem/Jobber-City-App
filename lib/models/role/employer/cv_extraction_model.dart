class CvExtractionResponseModel {
  final String resumeUrl;
  final ParsedDataModel? parsedData;

  CvExtractionResponseModel({required this.resumeUrl, this.parsedData});

  factory CvExtractionResponseModel.fromJson(Map<String, dynamic> json) {
    return CvExtractionResponseModel(
      resumeUrl: json['resume_url'] ?? '',
      parsedData: json['parsed_data'] != null
          ? ParsedDataModel.fromJson(json['parsed_data'])
          : null,
    );
  }
}

class ParsedDataModel {
  final ParsedPersonalInfoModel? personalInfo;
  final List<String> skills;
  final List<ParsedExperienceModel> experiences;
  final List<ParsedEducationModel> educations;

  ParsedDataModel({
    this.personalInfo,
    required this.skills,
    required this.experiences,
    required this.educations,
  });

  factory ParsedDataModel.fromJson(Map<String, dynamic> json) {
    return ParsedDataModel(
      personalInfo: json['personal_info'] != null
          ? ParsedPersonalInfoModel.fromJson(json['personal_info'])
          : null,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
                .map((e) => ParsedExperienceModel.fromJson(e))
                .toList()
          : [],
      educations: json['educations'] != null
          ? (json['educations'] as List)
                .map((e) => ParsedEducationModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class ParsedPersonalInfoModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? biography;

  ParsedPersonalInfoModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.biography,
  });

  factory ParsedPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return ParsedPersonalInfoModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      biography: json['biography'],
    );
  }
}

class ParsedExperienceModel {
  final String jobTitle;
  final String companyName;
  final String? startDate;
  final String? endDate;
  final String? description;

  ParsedExperienceModel({
    required this.jobTitle,
    required this.companyName,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory ParsedExperienceModel.fromJson(Map<String, dynamic> json) {
    return ParsedExperienceModel(
      jobTitle: json['job_title'] ?? '',
      companyName: json['company_name'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
    );
  }
}

class ParsedEducationModel {
  final String schoolName;
  final String degree;
  final String? fieldOfStudy;
  final String? startDate;
  final String? endDate;
  final String? description;

  ParsedEducationModel({
    required this.schoolName,
    required this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory ParsedEducationModel.fromJson(Map<String, dynamic> json) {
    return ParsedEducationModel(
      schoolName: json['school_name'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['field_of_study'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
    );
  }
}
