class CompanyProfileRequest {
  final String companyName;
  final String industryId;
  final String companySize;
  final String description;
  final String contactEmail;
  final String contactPhone;
  final String? websiteUrl;
  final String provinceId;
  final String districtId;
  final String addressDetail;

  CompanyProfileRequest({
    required this.companyName,
    required this.industryId,
    required this.companySize,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    this.websiteUrl,
    required this.provinceId,
    required this.districtId,
    required this.addressDetail,
  });

  Map<String, dynamic> toJson() {
    return {
      "company_name": companyName,
      "industry_id": industryId,
      "company_size": companySize,
      "description": description,
      "contact_email": contactEmail,
      "contact_phone": contactPhone,
      "website_url": websiteUrl ?? "",
      "province_id": provinceId,
      "district_id": districtId,
      "address_detail": addressDetail,
    };
  }
}

class CompanyProfileResponse {
  final bool success;
  final String message;
  final CompanyProfileModel? data;

  CompanyProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CompanyProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompanyProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CompanyProfileModel.fromJson(json['data'])
          : null,
    );
  }
}

class CompanyProfileModel {
  final String id;
  final String userId;
  final String companyName;
  final String industryId;
  final String companySize;
  final String description;
  final String contactEmail;
  final String contactPhone;
  final String? websiteUrl;
  final String provinceId;
  final String districtId;
  final String addressDetail;
  final String? logoUrl;
  final String? bannerUrl;
  final bool isVerified;
  final String status;

  CompanyProfileModel({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.industryId,
    required this.companySize,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    this.websiteUrl,
    required this.provinceId,
    required this.districtId,
    required this.addressDetail,
    this.logoUrl,
    this.bannerUrl,
    required this.isVerified,
    required this.status,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyProfileModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      companyName: json['company_name'] ?? '',
      industryId: json['industry_id'] ?? '',
      companySize: json['company_size'] ?? '',
      description: json['description'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      websiteUrl: json['website_url'],
      provinceId: json['province_id'] ?? '',
      districtId: json['district_id'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      logoUrl: json['logo_url'],
      bannerUrl: json['banner_url'],
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? 'pending',
    );
  }
}
