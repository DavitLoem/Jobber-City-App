// ឯកសារ: cv_parsed_data_model.dart

class CvExtractionResponseModel {
  final String resumeUrl;
  final String resumeFilename;
  final ParsedDataModel parsedData;

  CvExtractionResponseModel({
    required this.resumeUrl,
    required this.resumeFilename,
    required this.parsedData,
  });

  factory CvExtractionResponseModel.fromJson(Map<String, dynamic> json) {
    return CvExtractionResponseModel(
      resumeUrl: json['resume_url'] ?? '',
      resumeFilename: json['resume_filename'] ?? '',
      // ទោះបី parsed_data មកទទេ ក៏យើងការពារដោយបញ្ជូន {} ទៅ
      parsedData: ParsedDataModel.fromJson(json['parsed_data'] ?? {}),
    );
  }
}

class ParsedDataModel {
  final PersonalInfoModel? personalInfo;
  final List<String> skills;
  final List<ExperienceModel> experiences;
  final List<EducationModel> educations;

  ParsedDataModel({
    this.personalInfo,
    required this.skills,
    required this.experiences,
    required this.educations,
  });

  factory ParsedDataModel.fromJson(Map<String, dynamic> json) {
    return ParsedDataModel(
      // personal_info អាចនឹងអត់មាន (null) បើគាត់មានលេខទូរស័ព្ទក្នុង DB ហើយ
      personalInfo: json['personal_info'] != null
          ? PersonalInfoModel.fromJson(json['personal_info'])
          : null,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
                .map((e) => ExperienceModel.fromJson(e))
                .toList()
          : [],
      educations: json['educations'] != null
          ? (json['educations'] as List)
                .map((e) => EducationModel.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal_info': personalInfo?.toJson(),
      'skills': skills,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonalInfoModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? biography;

  PersonalInfoModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.biography,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      biography: json['biography'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'biography': biography,
    };
  }
}

class ExperienceModel {
  String? jobTitle;
  String? companyName;
  String? startDate;
  String? endDate;
  String? description;

  ExperienceModel({
    this.jobTitle,
    this.companyName,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      jobTitle: json['job_title'],
      companyName: json['company_name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'company_name': companyName,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
    };
  }
}

class EducationModel {
  String? schoolName;
  String? degree;
  String? fieldOfStudy;
  String? startDate;
  String? endDate;
  String? description;

  EducationModel({
    this.schoolName,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      schoolName: json['school_name'],
      degree: json['degree'],
      fieldOfStudy: json['field_of_study'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
    };
  }
}
