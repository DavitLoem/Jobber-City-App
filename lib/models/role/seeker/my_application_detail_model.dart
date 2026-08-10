class StatusHistory {
  final String status;
  final DateTime date;

  StatusHistory({required this.status, required this.date});

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    // 🎯 ដំណោះស្រាយ៖ ឆែកមើលអក្សរ Z
    String dateStr = json['date'] ?? '';

    // បើអត់មាន Z យើងត្រូវថែមវាពីក្រោយ ដើម្បីបង្ខំឱ្យ Flutter ដឹងថាវាជាម៉ោង UTC ជានិច្ច
    if (dateStr.isNotEmpty && !dateStr.endsWith('Z')) {
      dateStr += 'Z';
    }

    return StatusHistory(
      status: json['status'] ?? 'pending',
      // បន្ទាប់ពីថែម Z រួច យើងបំប្លែងទៅ Local នៅទីនេះតែម្តង
      date: dateStr.isNotEmpty
          ? DateTime.parse(dateStr).toLocal()
          : DateTime.now(),
    );
  }
}

class InterviewSchedule {
  final DateTime date;
  final String location;
  final String contactPhone;
  final String message;

  InterviewSchedule({
    required this.date,
    required this.location,
    required this.contactPhone,
    required this.message,
  });

  factory InterviewSchedule.fromJson(Map<String, dynamic> json) {
    return InterviewSchedule(
      date: DateTime.parse(json['date']),
      location: json['location'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class MyApplicationDetailModel {
  final String applicationId;
  final String jobId;
  final String companyId;
  final String jobTitle;
  final String companyName;
  final String? companyLogo;
  final String coverLetter;
  final String? resumeUrl;
  final String status;
  final List<StatusHistory> statusHistory;
  final InterviewSchedule? interviewSchedule;
  final String feedback;
  final DateTime appliedAt;

  MyApplicationDetailModel({
    required this.applicationId,
    required this.jobId,
    required this.companyId,
    required this.jobTitle,
    required this.companyName,
    this.companyLogo,
    required this.coverLetter,
    this.resumeUrl,
    required this.status,
    required this.statusHistory,
    this.interviewSchedule,
    required this.feedback,
    required this.appliedAt,
  });

  factory MyApplicationDetailModel.fromJson(Map<String, dynamic> json) {
    return MyApplicationDetailModel(
      applicationId: json['application_id'] ?? '',
      jobId: json['job_id'] ?? '',
      companyId: json['company_id'] ?? '',
      jobTitle: json['job_title'] ?? 'Unknown Job',
      companyName: json['company_name'] ?? 'Unknown Company',
      companyLogo: json['company_logo'],
      coverLetter: json['cover_letter'] ?? '',
      resumeUrl: json['resume_url'],
      status: json['status'] ?? 'pending',
      statusHistory:
          (json['status_history'] as List?)
              ?.map((e) => StatusHistory.fromJson(e))
              .toList() ??
          [],
      interviewSchedule:
          json['interview_schedule'] != null &&
              json['interview_schedule'].isNotEmpty
          ? InterviewSchedule.fromJson(json['interview_schedule'])
          : null,
      feedback: json['feedback'] ?? '',
      appliedAt: DateTime.parse(json['applied_at']),
    );
  }
}
