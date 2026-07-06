class ExperienceModel {
  String? jobTitle;
  String? companyName;
  String? startDate;
  String? endDate;
  bool? isCurrentJob;
  String? description;

  ExperienceModel({
    this.jobTitle,
    this.companyName,
    this.startDate,
    this.endDate,
    this.isCurrentJob,
    this.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      jobTitle: json['job_title'],
      companyName: json['company_name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isCurrentJob: json['is_current_job'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'company_name': companyName,
      'start_date': startDate,
      'end_date': endDate,
      'is_current_job': isCurrentJob,
      'description': description,
    };
  }
}
