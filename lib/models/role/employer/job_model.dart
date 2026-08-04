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
    "custom_skills": customSkills,
    "province_id": provinceId,
    "district_id": districtId,
    "closing_date": closingDate,
  };
}

class JobListResponseModel {
  final bool success;
  final String message;
  final List<JobDataModel> data;

  JobListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JobListResponseModel.fromJson(Map<String, dynamic> json) =>
      JobListResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<JobDataModel>.from(
                json["data"].map((x) => JobDataModel.fromJson(x)),
              )
            : [],
      );
}

class JobSingleResponseModel {
  final bool success;
  final String message;
  final JobDataModel? data;

  JobSingleResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory JobSingleResponseModel.fromJson(Map<String, dynamic> json) =>
      JobSingleResponseModel(
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
  final String provinceId;
  final String categoryId;
  final String jobLevelId;
  final String workTypeId;
  final String employmentTypeId;
  final String educationLevelId;
  final List<String> requiredSkills;
  final List<String> customSkills;
  final String districtId;
  final String status;
  final String closingDate;
  final String createdAt;

  JobDataModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.provinceId,
    required this.categoryId,
    required this.status,
    required this.createdAt,
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
    required this.jobLevelId,
    required this.workTypeId,
    required this.employmentTypeId,
    required this.educationLevelId,
    required this.requiredSkills,
    required this.customSkills,
    required this.districtId,
    required this.closingDate,
  });

  JobDataModel copyWith({
    String? id,
    String? companyId,
    String? title,
    List<String>? description,
    List<String>? requirements,
    List<String>? benefits,
    num? minSalary,
    num? maxSalary,
    String? salaryPeriod,
    bool? isNegotiable,
    int? headcount,
    String? experience,
    String? workingDays,
    String? workingHours,
    List<SpecificSchedule>? specificSchedule,
    String? provinceId,
    String? categoryId,
    String? jobLevelId,
    String? workTypeId,
    String? employmentTypeId,
    String? educationLevelId,
    List<String>? requiredSkills,
    List<String>? customSkills,
    String? districtId,
    String? status,
    String? closingDate,
    String? createdAt,
  }) {
    return JobDataModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      provinceId: provinceId ?? this.provinceId,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      headcount: headcount ?? this.headcount,
      experience: experience ?? this.experience,
      workingDays: workingDays ?? this.workingDays,
      workingHours: workingHours ?? this.workingHours,
      specificSchedule: specificSchedule ?? this.specificSchedule,
      jobLevelId: jobLevelId ?? this.jobLevelId,
      workTypeId: workTypeId ?? this.workTypeId,
      employmentTypeId: employmentTypeId ?? this.employmentTypeId,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      customSkills: customSkills ?? this.customSkills,
      districtId: districtId ?? this.districtId,
      closingDate: closingDate ?? this.closingDate,
    );
  }

  factory JobDataModel.fromJson(Map<String, dynamic> json) => JobDataModel(
    id: json["id"] ?? "",
    companyId: json["company_id"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] != null
        ? List<String>.from(json["description"])
        : [],
    requirements: json["requirements"] != null
        ? List<String>.from(json["requirements"])
        : [],
    benefits: json["benefits"] != null
        ? List<String>.from(json["benefits"])
        : [],
    minSalary: json["min_salary"] ?? 0,
    maxSalary: json["max_salary"] ?? 0,
    salaryPeriod: json["salary_period"] ?? "",
    isNegotiable: json["is_negotiable"] ?? false,
    headcount: json["headcount"] ?? 0,
    experience: json["experience"] ?? "",
    workingDays: json["working_days"] ?? "",
    workingHours: json["working_hours"] ?? "",
    specificSchedule: json["specific_schedule"] != null
        ? List<SpecificSchedule>.from(
            json["specific_schedule"].map((x) => SpecificSchedule.fromJson(x)),
          )
        : [],
    provinceId: json["province_id"] ?? "",
    categoryId: json["category_id"] ?? "",
    jobLevelId: json["job_level_id"] ?? "",
    workTypeId: json["work_type_id"] ?? "",
    employmentTypeId: json["employment_type_id"] ?? "",
    educationLevelId: json["education_level_id"] ?? "",
    requiredSkills: json["required_skills"] != null
        ? List<String>.from(json["required_skills"])
        : [],
    customSkills: json["custom_skills"] != null
        ? List<String>.from(json["custom_skills"])
        : [],
    districtId: json["district_id"] ?? "",
    status: json["status"] ?? "",
    closingDate: json["closing_date"] ?? "",
    createdAt: json["created_at"] ?? "",
  );
}
