class JobRecommendedModel {
  final int id;
  final String title;
  final double minSalary;
  final double maxSalary;
  final String salaryPeriod;
  final String companyName;
  final String logoUrl;
  final String location;
  final String employmentType;
  final bool isSaved;

  JobRecommendedModel({
    required this.id,
    required this.title,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.companyName,
    required this.logoUrl,
    required this.location,
    required this.employmentType,
    required this.isSaved,
  });

  factory JobRecommendedModel.fromJson(Map<String, dynamic> json) {
    return JobRecommendedModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      minSalary: (json['min_salary'] ?? 0.0).toDouble(),
      maxSalary: (json['max_salary'] ?? 0.0).toDouble(),
      salaryPeriod: json['salary_period'] ?? '',
      companyName: json['company_name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      location: json['location'] ?? '',
      employmentType: json['employment_type'] ?? '',
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
      'is_saved': isSaved,
    };
  }

  JobRecommendedModel copyWith({bool? isSaved}) {
    return JobRecommendedModel(
      id: id,
      title: title,
      minSalary: minSalary,
      maxSalary: maxSalary,
      salaryPeriod: salaryPeriod,
      companyName: companyName,
      logoUrl: logoUrl,
      location: location,
      employmentType: employmentType,
      isSaved:
          isSaved ?? this.isSaved, // 🟢 ប្រើតម្លៃថ្មីបើមាន បើគ្មានប្រើតម្លៃចាស់
    );
  }
}
