// To parse this JSON data, do
//
//     final jobPostModel = jobPostModelFromJson(jsonString);

import 'dart:convert';

JobPostModel jobPostModelFromJson(String str) =>
    JobPostModel.fromJson(json.decode(str));

String jobPostModelToJson(JobPostModel data) => json.encode(data.toJson());

class JobPostModel {
  String title;
  List<String> description;
  List<String> requirements;
  List<String> benefits;
  int minSalary;
  int maxSalary;
  String salaryPeriod;
  bool isNegotiable;
  int headcount;
  String experience;
  String workingDays;
  String workingHours;
  List<SpecificSchedule> specificSchedule;
  String categoryId;
  String jobLevelId;
  String workTypeId;
  String employmentTypeId;
  String educationLevelId;
  List<String> requiredSkills;
  String provinceId;
  String districtId;
  String closingDate;

  JobPostModel({
    required this.title,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.isNegotiable,
    required this.headcount,
    required this.experience,
    required this.workingDays,
    required this.workingHours,
    required this.specificSchedule,
    required this.categoryId,
    required this.jobLevelId,
    required this.workTypeId,
    required this.employmentTypeId,
    required this.educationLevelId,
    required this.requiredSkills,
    required this.provinceId,
    required this.districtId,
    required this.closingDate,
  });

  factory JobPostModel.fromJson(Map<String, dynamic> json) => JobPostModel(
    title: json["title"],
    description: List<String>.from(json["description"].map((x) => x)),
    requirements: List<String>.from(json["requirements"].map((x) => x)),
    benefits: List<String>.from(json["benefits"].map((x) => x)),
    minSalary: json["min_salary"],
    maxSalary: json["max_salary"],
    salaryPeriod: json["salary_period"],
    isNegotiable: json["is_negotiable"],
    headcount: json["headcount"],
    experience: json["experience"],
    workingDays: json["working_days"],
    workingHours: json["working_hours"],
    specificSchedule: List<SpecificSchedule>.from(
      json["specific_schedule"].map((x) => SpecificSchedule.fromJson(x)),
    ),
    categoryId: json["category_id"],
    jobLevelId: json["job_level_id"],
    workTypeId: json["work_type_id"],
    employmentTypeId: json["employment_type_id"],
    educationLevelId: json["education_level_id"],
    requiredSkills: List<String>.from(json["required_skills"].map((x) => x)),
    provinceId: json["province_id"],
    districtId: json["district_id"],
    closingDate: json["closing_date"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": List<dynamic>.from(description.map((x) => x)),
    "requirements": List<dynamic>.from(requirements.map((x) => x)),
    "benefits": List<dynamic>.from(benefits.map((x) => x)),
    "min_salary": minSalary,
    "max_salary": maxSalary,
    "salary_period": salaryPeriod,
    "is_negotiable": isNegotiable,
    "headcount": headcount,
    "experience": experience,
    "working_days": workingDays,
    "working_hours": workingHours,
    "specific_schedule": List<dynamic>.from(
      specificSchedule.map((x) => x.toJson()),
    ),
    "category_id": categoryId,
    "job_level_id": jobLevelId,
    "work_type_id": workTypeId,
    "employment_type_id": employmentTypeId,
    "education_level_id": educationLevelId,
    "required_skills": List<dynamic>.from(requiredSkills.map((x) => x)),
    "province_id": provinceId,
    "district_id": districtId,
    "closing_date": closingDate,
  };
}

class SpecificSchedule {
  String day;
  String hours;

  SpecificSchedule({required this.day, required this.hours});

  factory SpecificSchedule.fromJson(Map<String, dynamic> json) =>
      SpecificSchedule(day: json["day"], hours: json["hours"]);

  Map<String, dynamic> toJson() => {"day": day, "hours": hours};
}
