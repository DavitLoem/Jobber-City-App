import 'dart:convert';

EmployerJobModel employerJobModelFromJson(String str) =>
    EmployerJobModel.fromJson(json.decode(str));

String employerJobModelToJson(EmployerJobModel data) =>
    json.encode(data.toJson());

class EmployerJobModel {
  String id;
  String title;
  String status;
  String createdAt;
  double minSalary;
  double maxSalary;
  String salaryPeriod;
  bool isNegotiable;
  String experience;
  String workingDays;
  String workingHours;
  int headcount;
  String categoryId;
  String jobLevelId;
  String workTypeId;
  String employmentTypeId;
  String educationLevelId;
  String provinceId;
  String districtId;
  String closingDate;
  List<String> requiredSkills;
  List<String> benefits;

  EmployerJobModel({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.isNegotiable,
    required this.experience,
    required this.workingDays,
    required this.workingHours,
    required this.headcount,
    required this.categoryId,
    required this.jobLevelId,
    required this.workTypeId,
    required this.employmentTypeId,
    required this.educationLevelId,
    required this.provinceId,
    required this.districtId,
    required this.closingDate,
    required this.requiredSkills,
    required this.benefits,
  });

  factory EmployerJobModel.fromJson(Map<String, dynamic> json) =>
      EmployerJobModel(
        id: json["id"]?.toString() ?? json["_id"]?.toString() ?? '',
        title: json["title"]?.toString() ?? 'Untitled Job',
        status: json["status"]?.toString() ?? 'active',
        createdAt: json["created_at"]?.toString() ??
            json["createdAt"]?.toString() ??
            json["posted_at"]?.toString() ??
            '',
        minSalary: double.tryParse((json["min_salary"] ?? json["minSalary"] ?? 0).toString()) ?? 0.0,
        maxSalary: double.tryParse((json["max_salary"] ?? json["maxSalary"] ?? 0).toString()) ?? 0.0,
        salaryPeriod: json["salary_period"]?.toString() ??
            json["salaryPeriod"]?.toString() ??
            '',
        isNegotiable: json["is_negotiable"] is bool
            ? json["is_negotiable"]
            : (json["is_negotiable"] == null ? true : json["is_negotiable"].toString() == 'true'),
        experience: json["experience"]?.toString() ?? '',
        workingDays: json["working_days"]?.toString() ??
            json["workingDays"]?.toString() ??
            '',
        workingHours: json["working_hours"]?.toString() ??
            json["workingHours"]?.toString() ??
            '',
        headcount: int.tryParse((json["headcount"] ?? json["vacancies"] ?? 1).toString()) ?? 1,
        categoryId: json["category_id"]?.toString() ?? json["categoryId"]?.toString() ?? '',
        jobLevelId: json["job_level_id"]?.toString() ?? json["jobLevelId"]?.toString() ?? '',
        workTypeId: json["work_type_id"]?.toString() ?? json["workTypeId"]?.toString() ?? '',
        employmentTypeId: json["employment_type_id"]?.toString() ?? json["employmentTypeId"]?.toString() ?? '',
        educationLevelId: json["education_level_id"]?.toString() ?? json["educationLevelId"]?.toString() ?? '',
        provinceId: json["province_id"]?.toString() ?? '',
        districtId: json["district_id"]?.toString() ?? '',
        closingDate: json["closing_date"]?.toString() ?? '',
        requiredSkills: _asStringList(json["required_skills"]),
        benefits: _asStringList(json["benefits"] ?? json["perks"] ?? json["job_benefits"]),
      );

  static List<String> _asStringList(dynamic value) {
    if (value == null) return [];
    final list = value is List ? value : [value];
    return list.map<String>((e) {
      if (e is Map) {
        final name = e['name'] ??
            e['title'] ??
            e['skill'] ??
            e['text'] ??
            e['value'] ??
            e['label'] ??
            e['benefit'] ??
            e['benefit_name'] ??
            e['perk'] ??
            e['description'] ??
            e['benefit_description'] ??
            e['details'] ??
            e['benefit_text'];
        if (name != null && name.toString().trim().isNotEmpty) {
          return name.toString().trim();
        }
        for (final entry in e.entries) {
          final key = entry.key.toString().toLowerCase();
          if (key == '_id' ||
              key == 'id' ||
              key == 'order' ||
              key == 'is_active' ||
              key == 'active' ||
              key == 'created_at' ||
              key == 'updated_at' ||
              key == 'createdAt' ||
              key == 'updatedAt' ||
              key.startsWith('is_') ||
              key == 'status' ||
              key == 'benefit_id' ||
              key == 'skill_id') {
            continue;
          }
          final v = entry.value;
          if (v is String && v.trim().isNotEmpty) return v.trim();
        }
      }
      return e?.toString().trim() ?? '';
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "created_at": createdAt,
        "min_salary": minSalary,
        "max_salary": maxSalary,
        "salary_period": salaryPeriod,
        "is_negotiable": isNegotiable,
        "experience": experience,
        "working_days": workingDays,
        "working_hours": workingHours,
        "headcount": headcount,
        "category_id": categoryId,
        "job_level_id": jobLevelId,
        "work_type_id": workTypeId,
        "employment_type_id": employmentTypeId,
        "education_level_id": educationLevelId,
        "province_id": provinceId,
        "district_id": districtId,
        "closing_date": closingDate,
        "required_skills": requiredSkills,
        "benefits": benefits,
      };
}
