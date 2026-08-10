class JobDropdownItemModel {
  final String jobId;
  final String displayName;
  final String status;

  JobDropdownItemModel({
    required this.jobId,
    required this.displayName,
    required this.status,
  });

  factory JobDropdownItemModel.fromJson(Map<String, dynamic> json) {
    return JobDropdownItemModel(
      jobId: json['job_id'] ?? '',
      displayName: json['display_name'] ?? 'Unknown Job',
      status: json['status'] ?? 'active',
    );
  }
}
