class JobRecentModel {
  final String id;
  final String title;
  final double minSalary; // 🟢 ប្តូរមកជា double
  final double maxSalary; // 🟢 ប្តូរមកជា double
  final String salaryPeriod;
  final String companyName;
  final String logoUrl;
  final String location;
  final String employmentType;
  final String workType;
  final bool isSaved;

  JobRecentModel({
    required this.id,
    required this.title,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.companyName,
    required this.logoUrl,
    required this.location,
    required this.employmentType,
    required this.workType,
    required this.isSaved,
  });

  factory JobRecentModel.fromJson(Map<String, dynamic> json) {
    return JobRecentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      // 🟢 បំប្លែងទៅជា double ដោយសុវត្ថិភាពទោះ API បោះមកជាអ្វីក៏ដោយ
      minSalary: double.tryParse(json['min_salary']?.toString() ?? '0') ?? 0.0,
      maxSalary: double.tryParse(json['max_salary']?.toString() ?? '0') ?? 0.0,
      salaryPeriod: json['salary_period']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      logoUrl: json['logo_url']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      employmentType: json['employment_type']?.toString() ?? '',
      workType: json['work_type']?.toString() ?? '',
      isSaved: json['is_saved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'salary_period': salaryPeriod,
      'company_name': companyName,
      'logo_url': logoUrl,
      'location': location,
      'employment_type': employmentType,
      'work_type': workType,
      'is_saved': isSaved,
    };
  }

  JobRecentModel copyWith({bool? isSaved}) {
    return JobRecentModel(
      id: id,
      title: title,
      minSalary: minSalary,
      maxSalary: maxSalary,
      salaryPeriod: salaryPeriod,
      companyName: companyName,
      logoUrl: logoUrl,
      location: location,
      employmentType: employmentType,
      workType: workType,
      isSaved:
          isSaved ?? this.isSaved, // 🟢 ប្រើតម្លៃថ្មីបើមាន បើគ្មានប្រើតម្លៃចាស់
    );
  }
}
