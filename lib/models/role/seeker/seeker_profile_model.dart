class SeekerProfileResponse {
  final bool success;
  final String message;
  final SeekerProfileModel? data;

  SeekerProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SeekerProfileResponse.fromJson(Map<String, dynamic> json) {
    return SeekerProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SeekerProfileModel.fromJson(json['data'])
          : null,
    );
  }
}

class SeekerProfileModel {
  final String id;
  final String userId;
  final String profileImageUrl;
  final num profileCompletionPercentage;
  final bool onboardingCompleted;

  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String nationality;
  final String currentPosition;

  final String email;
  final String phoneNumber;

  final String provinceId;
  final String districtId;

  final String addressProvinceId;
  final String addressDistrictId;
  final String commune;
  final String village;
  final String street;
  final String houseNo;

  final String biography;
  final num expectedSalaryMin;
  final num expectedSalaryMax;

  final List<String> jobTypePreferences;
  final List<String> expertiseCategoryIds;
  final List<String> skills;

  final String resumeUrl;
  final String portfolioUrl;
  final String linkedinUrl;

  // Array បន្ថែមដែលទាន់មិនមានទិន្នន័យលម្អិត
  final List<dynamic> experiences;
  final List<dynamic> educations;
  final List<dynamic> trainings;
  final List<dynamic> languages;

  SeekerProfileModel({
    required this.id,
    required this.userId,
    required this.profileImageUrl,
    required this.profileCompletionPercentage,
    required this.onboardingCompleted,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.currentPosition,
    required this.email,
    required this.phoneNumber,
    required this.provinceId,
    required this.addressProvinceId,
    required this.addressDistrictId,
    required this.districtId,
    required this.commune,
    required this.village,
    required this.street,
    required this.houseNo,
    required this.biography,
    required this.expectedSalaryMin,
    required this.expectedSalaryMax,
    required this.jobTypePreferences,
    required this.expertiseCategoryIds,
    required this.skills,
    required this.resumeUrl,
    required this.portfolioUrl,
    required this.linkedinUrl,
    required this.experiences,
    required this.educations,
    required this.trainings,
    required this.languages,
  });

  factory SeekerProfileModel.fromJson(Map<String, dynamic> json) {
    return SeekerProfileModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      profileCompletionPercentage: json['profile_completion_percentage'] ?? 0,
      onboardingCompleted: json['onboarding_completed'] ?? false,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      nationality: json['nationality'] ?? '',
      currentPosition: json['current_position'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      provinceId: json['province_id'] ?? '',
      districtId: json['district_id'] ?? '',
      addressProvinceId: json['address_province_id'] ?? '',
      addressDistrictId: json['address_district_id'] ?? '',
      commune: json['commune'] ?? '',
      village: json['village'] ?? '',
      street: json['street'] ?? '',
      houseNo: json['house_no'] ?? '',
      biography: json['biography'] ?? '',
      expectedSalaryMin: json['expected_salary_min'] ?? 0,
      expectedSalaryMax: json['expected_salary_max'] ?? 0,
      jobTypePreferences: List<String>.from(json['job_type_preferences'] ?? []),
      expertiseCategoryIds: List<String>.from(
        json['expertise_category_ids'] ?? [],
      ),
      skills: List<String>.from(json['skills'] ?? []),
      resumeUrl: json['resume_url'] ?? '',
      portfolioUrl: json['portfolio_url'] ?? '',
      linkedinUrl: json['linkedin_url'] ?? '',
      experiences: json['experiences'] ?? [],
      educations: json['educations'] ?? [],
      trainings: json['trainings'] ?? [],
      languages: json['languages'] ?? [],
    );
  }
}

class SeekerCoreUpdateRequest {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String nationality;
  final String currentPosition;

  final String email;
  final String phoneNumber;

  final String addressProvinceId;
  final String addressDistrictId;

  final String commune;
  final String village;
  final String street;
  final String houseNo;

  final String biography;
  final num expectedSalaryMin;
  final num expectedSalaryMax;

  final List<String> jobTypePreferences;
  final List<String> expertiseCategoryIds;
  final List<String> skills;

  final String portfolioUrl;
  final String linkedinUrl;
  final bool onboardingCompleted;

  SeekerCoreUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.nationality,
    required this.currentPosition,
    required this.email,
    required this.phoneNumber,
    required this.addressProvinceId,
    required this.addressDistrictId,
    required this.commune,
    required this.village,
    required this.street,
    required this.houseNo,
    required this.biography,
    required this.expectedSalaryMin,
    required this.expectedSalaryMax,
    required this.jobTypePreferences,
    required this.expertiseCategoryIds,
    required this.skills,
    required this.portfolioUrl,
    required this.linkedinUrl,
    required this.onboardingCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dateOfBirth,
      "gender": gender,
      "marital_status": maritalStatus,
      "nationality": nationality,
      "current_position": currentPosition,
      "email": email,
      "phone_number": phoneNumber,
      'address_province_id': addressProvinceId,
      'address_district_id': addressDistrictId,
      "commune": commune,
      "village": village,
      "street": street,
      "house_no": houseNo,
      "biography": biography,
      "expected_salary_min": expectedSalaryMin,
      "expected_salary_max": expectedSalaryMax,
      "job_type_preferences": jobTypePreferences,
      "expertise_category_ids": expertiseCategoryIds,
      "skills": skills,
      "portfolio_url": portfolioUrl,
      "linkedin_url": linkedinUrl,
      "onboarding_completed": onboardingCompleted,
    };
  }
}
