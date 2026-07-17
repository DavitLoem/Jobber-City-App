class SpecificSchedule {
  final String day;
  final String hours;

  SpecificSchedule({required this.day, required this.hours});

  factory SpecificSchedule.fromJson(Map<String, dynamic> json) =>
      SpecificSchedule(day: json["day"] ?? "", hours: json["hours"] ?? "");

  Map<String, dynamic> toJson() => {"day": day, "hours": hours};
}

class JobRequestModel {
  final String title;
  final List<String> description;
  final List<String> requirements;
  final List<String> benefits;
  final num minSalary;
  final num maxSalary;
  final String salaryPeriod;
  final bool isNegotiable;
  final int headcount;
  final String experience;
  final String workingDays;
  final String workingHours;
  final List<SpecificSchedule> specificSchedule;
  final String categoryId;
  final String jobLevelId;
  final String workTypeId;
  final String employmentTypeId;
  final String educationLevelId;
  final List<String> requiredSkills;
  final List<String> customSkills;
  final String provinceId;
  final String districtId;
  final String closingDate;

  JobRequestModel({
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
    required this.customSkills,
    required this.provinceId,
    required this.districtId,
    required this.closingDate,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "requirements": requirements,
    "benefits": benefits,
    "min_salary": minSalary,
    "max_salary": maxSalary,
    "salary_period": salaryPeriod,
    "is_negotiable": isNegotiable,
    "headcount": headcount,
    "experience": experience,
    "working_days": workingDays,
    "working_hours": workingHours,
    "specific_schedule": specificSchedule.map((x) => x.toJson()).toList(),
    "category_id": categoryId,
    "job_level_id": jobLevelId,
    "work_type_id": workTypeId,
    "employment_type_id": employmentTypeId,
    "education_level_id": educationLevelId,
    "required_skills": requiredSkills,
    "province_id": provinceId,
    "district_id": districtId,
    "closing_date": closingDate,
  };
}

class JobResponseModel {
  final bool success;
  final String message;
  final JobDataModel? data;

  JobResponseModel({required this.success, required this.message, this.data});

  factory JobResponseModel.fromJson(Map<String, dynamic> json) =>
      JobResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? JobDataModel.fromJson(json["data"]) : null,
      );
}

class JobDataModel {
  final String id;
  final String companyId;
  final String title;
  final List<String> description;
  final String status;
  final String createdAt;

  JobDataModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory JobDataModel.fromJson(Map<String, dynamic> json) => JobDataModel(
    id: json["id"] ?? "",
    companyId: json["company_id"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] != null
        ? List<String>.from(json["description"])
        : [],
    status: json["status"] ?? "",
    createdAt: json["created_at"] ?? "",
  );
}
