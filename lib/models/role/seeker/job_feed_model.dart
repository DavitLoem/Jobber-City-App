class JobFeedModel {
  final String id;

  final String title;
  final double minSalary;
  final double maxSalary;
  final String salaryPeriod;

  // ព័ត៌មានលម្អិត (Detail Level)
  final List<String> description;
  final List<String> requirements;
  final List<String> benefits;
  final String experience;
  final String workingDays;
  final String workingHours;
  final bool isNegotiable;
  final int headcount;
  final DateTime? closingDate; // អាច Null បាន

  // ព័ត៌មានក្រុមហ៊ុន & Master Data
  final String companyName;
  final String? logoUrl; // អាច Null បាន
  final String location;
  final String employmentType;
  final String workType;

  // គ្រប់គ្រងប្រព័ន្ធ
  final DateTime createdAt;
  bool isSaved;
  bool hasApplied;
  final int? matchPercentage; // អាច Null បាន

  JobFeedModel({
    required this.id,
    required this.title,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryPeriod,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.experience,
    required this.workingDays,
    required this.workingHours,
    required this.isNegotiable,
    required this.headcount,
    this.closingDate,
    required this.companyName,
    this.logoUrl,
    required this.location,
    required this.employmentType,
    required this.workType,
    required this.createdAt,
    this.isSaved = false,
    this.hasApplied = false,
    this.matchPercentage,
  });

  /// មុខងារសម្រាប់បំប្លែងទិន្នន័យ JSON ពី API ទៅជា Object របស់ Flutter
  factory JobFeedModel.fromJson(Map<String, dynamic> json) {
    return JobFeedModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',

      // ការពារ Error ពេល Backend បោះមកជា Int (ឧ. 0) ជំនួសឱ្យ Double (0.0)
      minSalary: (json['min_salary'] ?? 0).toDouble(),
      maxSalary: (json['max_salary'] ?? 0).toDouble(),
      salaryPeriod: json['salary_period'] ?? '',

      // ការពារ Error ពេល Array បោះមកជា Null
      description: List<String>.from(json['description'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),

      experience: json['experience'] ?? '',
      workingDays: json['working_days'] ?? '',
      workingHours: json['working_hours'] ?? '',
      isNegotiable: json['is_negotiable'] ?? true,
      headcount: json['headcount'] ?? 1,

      // Parse ថ្ងៃខែ តែត្រូវឆែក Null សិន
      closingDate: json['closing_date'] != null
          ? DateTime.parse(json['closing_date'])
          : null,

      companyName: json['company_name'] ?? 'Unknown Company',
      logoUrl: json['logo_url'],
      location: json['location'] ?? '',
      employmentType: json['employment_type'] ?? '',
      workType: json['work_type'] ?? '',

      // ត្រូវប្រាកដថា created_at មានជានិច្ច
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),

      isSaved: json['is_saved'] ?? false,
      hasApplied: json['is_applied'] ?? false,
      matchPercentage: json['match_percentage'],
    );
  }
}
