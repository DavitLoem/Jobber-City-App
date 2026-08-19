class EmployerDashboardResponse {
  final OverviewStatsModel overview;
  final PipelineStatsModel pipeline;
  final List<RecentApplicantModel> recentApplicants;

  EmployerDashboardResponse({
    required this.overview,
    required this.pipeline,
    required this.recentApplicants,
  });

  factory EmployerDashboardResponse.fromJson(Map<String, dynamic> json) {
    return EmployerDashboardResponse(
      overview: OverviewStatsModel.fromJson(json['overview'] ?? {}),
      pipeline: PipelineStatsModel.fromJson(json['pipeline'] ?? {}),
      recentApplicants:
          (json['recent_applicants'] as List<dynamic>?)
              ?.map((e) => RecentApplicantModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OverviewStatsModel {
  final int jobsPosted;
  final String jobsPostedTrend;
  final int totalApplications;
  final String applicationsTrend;
  final int interviews;
  final String interviewsTrend;
  final int hired;
  final String hiredTrend;

  OverviewStatsModel({
    required this.jobsPosted,
    required this.jobsPostedTrend,
    required this.totalApplications,
    required this.applicationsTrend,
    required this.interviews,
    required this.interviewsTrend,
    required this.hired,
    required this.hiredTrend,
  });

  factory OverviewStatsModel.fromJson(Map<String, dynamic> json) {
    return OverviewStatsModel(
      jobsPosted: json['jobs_posted'] ?? 0,
      jobsPostedTrend: json['jobs_posted_trend'] ?? "0",
      totalApplications: json['total_applications'] ?? 0,
      applicationsTrend: json['applications_trend'] ?? "0",
      interviews: json['interviews'] ?? 0,
      interviewsTrend: json['interviews_trend'] ?? "0",
      hired: json['hired'] ?? 0,
      hiredTrend: json['hired_trend'] ?? "0",
    );
  }
}

class PipelineStatsModel {
  final int activeCandidates;
  final int screening;
  final int review;
  final int interview;
  final int offer;

  PipelineStatsModel({
    required this.activeCandidates,
    required this.screening,
    required this.review,
    required this.interview,
    required this.offer,
  });

  factory PipelineStatsModel.fromJson(Map<String, dynamic> json) {
    return PipelineStatsModel(
      activeCandidates: json['active_candidates'] ?? 0,
      screening: json['screening'] ?? 0,
      review: json['review'] ?? 0,
      interview: json['interview'] ?? 0,
      offer: json['offer'] ?? 0,
    );
  }
}

class RecentApplicantModel {
  final String applicantId;
  final String seekerId;
  final String name;
  final String avatarUrl;
  final String jobTitle;
  final String status;
  final DateTime? appliedAt;
  final double rating;

  RecentApplicantModel({
    required this.applicantId,
    required this.seekerId,
    required this.name,
    required this.avatarUrl,
    required this.jobTitle,
    required this.status,
    this.appliedAt,
    required this.rating,
  });

  factory RecentApplicantModel.fromJson(Map<String, dynamic> json) {
    return RecentApplicantModel(
      applicantId: json['applicant_id'] ?? '',
      seekerId: json['seeker_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatar_url'] ?? '',
      jobTitle: json['job_title'] ?? '',
      status: json['status'] ?? 'Pending',
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'])
          : null,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}
