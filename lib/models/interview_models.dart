class InterviewOtherParty {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String role;

  InterviewOtherParty({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.role,
  });

  factory InterviewOtherParty.fromJson(Map<String, dynamic> json) {
    // 🎯 ចាប់យកទាំង 'avatar_url' និង 'profile_image_url' រួច .trim() ការពារ Space
    String? rawAvatar =
        json['avatar_url']?.toString() ?? json['profile_image_url']?.toString();

    return InterviewOtherParty(
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      avatarUrl: rawAvatar?.trim(), // 🎯 កាត់ Space ចេញ
      role: json['role']?.toString() ?? '',
    );
  }
}

/// Mirrors `InterviewResponse` — one scheduled/past video interview.
class InterviewModel {
  final String id;
  final String? jobId;
  final String? jobTitle;
  final String? applicationId;
  final InterviewOtherParty otherParty;
  final DateTime scheduledAt;
  final int durationMinutes;

  /// One of: scheduled, ongoing, completed, cancelled, no_show
  final String status;
  final String? notes;
  final String meetingUrl;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? cancelReason;
  final DateTime createdAt;

  InterviewModel({
    required this.id,
    this.jobId,
    this.jobTitle,
    this.applicationId,
    required this.otherParty,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    this.notes,
    required this.meetingUrl,
    this.startedAt,
    this.endedAt,
    this.cancelReason,
    required this.createdAt,
  });

  bool get isUpcoming => status == 'scheduled' || status == 'ongoing';
  bool get isCancellable => status == 'scheduled' || status == 'ongoing';
  bool get isJoinable => status == 'scheduled' || status == 'ongoing';

  factory InterviewModel.fromJson(Map<String, dynamic> json) => InterviewModel(
    id: json['id']?.toString() ?? '',
    jobId: json['job_id']?.toString(),
    jobTitle: json['job_title']?.toString(),
    applicationId: json['application_id']?.toString(),
    otherParty: InterviewOtherParty.fromJson(json['other_party'] ?? {}),
    scheduledAt:
        DateTime.tryParse(json['scheduled_at']?.toString() ?? '')?.toLocal() ??
        DateTime.now(),
    durationMinutes: json['duration_minutes'] ?? 30,
    status: json['status']?.toString() ?? 'scheduled',
    notes: json['notes'],
    meetingUrl: json['meeting_url']?.toString() ?? '',
    startedAt: json['started_at'] != null
        ? DateTime.tryParse(json['started_at'].toString())?.toLocal()
        : null,
    endedAt: json['ended_at'] != null
        ? DateTime.tryParse(json['ended_at'].toString())?.toLocal()
        : null,
    cancelReason: json['cancel_reason'],
    createdAt:
        DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal() ??
        DateTime.now(),
  );
}

/// Mirrors `JoinInterviewResponse` — returned right before opening the call.
class JoinInterviewResult {
  final String meetingUrl;
  final String roomName;
  final String displayName;
  final String status;

  JoinInterviewResult({
    required this.meetingUrl,
    required this.roomName,
    required this.displayName,
    required this.status,
  });

  factory JoinInterviewResult.fromJson(Map<String, dynamic> json) =>
      JoinInterviewResult(
        meetingUrl: json['meeting_url']?.toString() ?? '',
        roomName: json['room_name']?.toString() ?? '',
        displayName: json['display_name']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
      );
}

/// Navigation payload for `AppRoutes.scheduleInterview` — passed via
/// `Get.toNamed(..., arguments: ScheduleInterviewArgs(...))` from the
/// employer's candidate detail screen.
class ScheduleInterviewArgs {
  final String seekerUserId;
  final String seekerName;
  final String? seekerAvatarUrl;
  final String? applicationId;
  final String? jobTitle;

  ScheduleInterviewArgs({
    required this.seekerUserId,
    required this.seekerName,
    this.seekerAvatarUrl,
    this.applicationId,
    this.jobTitle,
  });
}
