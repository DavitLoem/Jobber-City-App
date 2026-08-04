class MyApplicationModel {
  final String applicationId;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String? companyLogo;
  final String status;
  final DateTime appliedAt;

  MyApplicationModel({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    this.companyLogo,
    required this.status,
    required this.appliedAt,
  });

  factory MyApplicationModel.fromJson(Map<String, dynamic> json) {
    return MyApplicationModel(
      applicationId: json['application_id'] ?? '',
      jobId: json['job_id'] ?? '',
      jobTitle: json['job_title'] ?? 'Unknown Job',
      companyName: json['company_name'] ?? 'Unknown Company',
      companyLogo: json['company_logo'],
      status: json['status'] ?? 'pending',
      appliedAt: DateTime.parse(json['applied_at']),
    );
  }
}
