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
  final String? coverLetter;
  final String status;
  final DateTime? appliedAt;

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
    this.coverLetter,
    required this.status,
    this.appliedAt,
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
      coverLetter: json['cover_letter'],
      status: json['status'] ?? 'pending',
      // បំប្លែងកាលបរិច្ឆេទ
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'].toString())?.toLocal()
          : null,
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
      coverLetter: coverLetter,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}
