class ApplicantStatusSummaryModel {
  final int all;
  final int pending;
  final int shortlisted;
  final int interview;
  final int hired;
  final int rejected;

  ApplicantStatusSummaryModel({
    required this.all,
    required this.pending,
    required this.shortlisted,
    required this.interview,
    required this.hired,
    required this.rejected,
  });

  factory ApplicantStatusSummaryModel.fromJson(Map<String, dynamic> json) {
    return ApplicantStatusSummaryModel(
      all: json['all'] ?? 0,
      pending: json['pending'] ?? 0,
      shortlisted: json['shortlisted'] ?? 0,
      interview: json['interview'] ?? 0,
      hired: json['hired'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}
