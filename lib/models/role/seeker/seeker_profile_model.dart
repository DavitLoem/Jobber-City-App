// To parse this JSON data, do
//
//     final seekerProflieModel = seekerProflieModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SeekerProflieModel seekerProflieModelFromJson(String str) =>
    SeekerProflieModel.fromJson(json.decode(str));

String seekerProflieModelToJson(SeekerProflieModel data) =>
    json.encode(data.toJson());

class SeekerProflieModel {
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String gender;
  String maritalStatus;
  String nationality;
  String currentPosition;
  String email;
  String phoneNumber;
  String provinceId;
  String districtId;
  String commune;
  String village;
  String street;
  String houseNo;
  String biography;
  int expectedSalaryMin;
  int expectedSalaryMax;
  List<String> jobTypePreferences;
  List<String> expertiseCategoryIds;
  List<String> skills;
  String portfolioUrl;
  String linkedinUrl;

  SeekerProflieModel({
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
    required this.portfolioUrl,
    required this.linkedinUrl,
  });

  factory SeekerProflieModel.fromJson(Map<String, dynamic> json) =>
      SeekerProflieModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        nationality: json["nationality"],
        currentPosition: json["current_position"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        provinceId: json["province_id"],
        districtId: json["district_id"],
        commune: json["commune"],
        village: json["village"],
        street: json["street"],
        houseNo: json["house_no"],
        biography: json["biography"],
        expectedSalaryMin: json["expected_salary_min"],
        expectedSalaryMax: json["expected_salary_max"],
        jobTypePreferences: List<String>.from(
          json["job_type_preferences"].map((x) => x),
        ),
        expertiseCategoryIds: List<String>.from(
          json["expertise_category_ids"].map((x) => x),
        ),
        skills: List<String>.from(json["skills"].map((x) => x)),
        portfolioUrl: json["portfolio_url"],
        linkedinUrl: json["linkedin_url"],
      );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "date_of_birth":
        "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "marital_status": maritalStatus,
    "nationality": nationality,
    "current_position": currentPosition,
    "email": email,
    "phone_number": phoneNumber,
    "province_id": provinceId,
    "district_id": districtId,
    "commune": commune,
    "village": village,
    "street": street,
    "house_no": houseNo,
    "biography": biography,
    "expected_salary_min": expectedSalaryMin,
    "expected_salary_max": expectedSalaryMax,
    "job_type_preferences": List<dynamic>.from(
      jobTypePreferences.map((x) => x),
    ),
    "expertise_category_ids": List<dynamic>.from(
      expertiseCategoryIds.map((x) => x),
    ),
    "skills": List<dynamic>.from(skills.map((x) => x)),
    "portfolio_url": portfolioUrl,
    "linkedin_url": linkedinUrl,
  };
}
