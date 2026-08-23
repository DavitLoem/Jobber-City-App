class ApplicantModel {
  final String applicationId;
  final String seekerUserId;
  final String jobTitle;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final String currentPosition;
  final List<String> skills;
  final int yearsOfExperience;
  final String? resumeUrl;
  final String? resumeFilename;
  final String? coverLetter;
  final String? coverLetterUrl;
  final String? coverLetterFilename;
  final String status;
  final DateTime? appliedAt;
  final Map<String, dynamic>? interviewSchedule;
  final String? feedback;

  ApplicantModel({
    required this.applicationId,
    required this.seekerUserId,
    required this.jobTitle,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    required this.currentPosition,
    required this.skills,
    required this.yearsOfExperience,
    this.resumeUrl,
    this.resumeFilename,
    this.coverLetter,
    this.coverLetterUrl,
    this.coverLetterFilename,
    required this.status,
    this.appliedAt,
    this.interviewSchedule,
    this.feedback,
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    return ApplicantModel(
      applicationId: json['application_id'] ?? '',
      seekerUserId: json['seeker_user_id'] ?? '',
      jobTitle: json['job_title'] ?? 'Unknown',
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      currentPosition: json['current_position'] ?? '',
      // បំប្លែងបញ្ជីជំនាញពី JSON ទៅជា List<String>
      skills: List<String>.from(json['skills'] ?? []),
      yearsOfExperience: json['years_of_experience'] ?? 0,
      resumeUrl: json['resume_url'],
      resumeFilename: json['resume_filename'],
      coverLetter: json['cover_letter'],
      coverLetterUrl: json['cover_letter_url'],
      coverLetterFilename: json['cover_letter_filename'],
      status: json['status'] ?? 'pending',
      // បំប្លែងកាលបរិច្ឆេទ
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'].toString())?.toLocal()
          : null,
      interviewSchedule: json['interview_schedule'],
      feedback: json['feedback'],
    );
  }

  // 🎯 Getter ជំនួយសម្រាប់យកឈ្មោះពេញ ដើម្បីកុំឱ្យពិបាកតគ្នាពីរដង
  String get fullName => '$lastName $firstName'.trim();

  // 🎯 copyWith គឺមានប្រយោជន៍ខ្លាំង ពេលយើងចង់ Update តែ Status របស់គាត់ក្នុង UI (ឧទាហរណ៍ ពេលចុច Shortlist)
  ApplicantModel copyWith({String? status}) {
    return ApplicantModel(
      applicationId: applicationId,
      seekerUserId: seekerUserId,
      jobTitle: jobTitle,
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
      currentPosition: currentPosition,
      skills: skills,
      yearsOfExperience: yearsOfExperience,
      resumeUrl: resumeUrl,
      resumeFilename: resumeFilename,
      coverLetter: coverLetter,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}
