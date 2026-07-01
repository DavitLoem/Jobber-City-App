// To parse this JSON data, do
//
//     final companyProfileModel = companyProfileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CompanyProfileModel companyProfileModelFromJson(String str) =>
    CompanyProfileModel.fromJson(json.decode(str));

String companyProfileModelToJson(CompanyProfileModel data) =>
    json.encode(data.toJson());

class CompanyProfileModel {
  String companyName;
  String industryId;
  String companySize;
  String description;
  String contactEmail;
  String contactPhone;
  String websiteUrl;
  String provinceId;
  String districtId;
  String addressDetail;

  CompanyProfileModel({
    required this.companyName,
    required this.industryId,
    required this.companySize,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    required this.websiteUrl,
    required this.provinceId,
    required this.districtId,
    required this.addressDetail,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) =>
      CompanyProfileModel(
        companyName: json["company_name"],
        industryId: json["industry_id"],
        companySize: json["company_size"],
        description: json["description"],
        contactEmail: json["contact_email"],
        contactPhone: json["contact_phone"],
        websiteUrl: json["website_url"],
        provinceId: json["province_id"],
        districtId: json["district_id"],
        addressDetail: json["address_detail"],
      );

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "industry_id": industryId,
    "company_size": companySize,
    "description": description,
    "contact_email": contactEmail,
    "contact_phone": contactPhone,
    "website_url": websiteUrl,
    "province_id": provinceId,
    "district_id": districtId,
    "address_detail": addressDetail,
  };
}
