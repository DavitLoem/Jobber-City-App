import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';

class CompanyProfileService {
  final ApiClient _apiClient = ApiClient();

  final String _baseUrl = '/employer/company-profile';

  Future<CompanyProfileResponse> createCompanyProfile(
    CompanyProfileRequest requestModel,
  ) async {
    try {
      final response = await _apiClient.post(
        '$_baseUrl/',
        data: requestModel.toJson(),
      );
      return CompanyProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CompanyProfileResponse> getMyCompanyProfile() async {
    try {
      final response = await _apiClient.get('$_baseUrl/me');
      return CompanyProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CompanyProfileResponse> updateCompanyProfile(
    CompanyProfileRequest requestModel,
  ) async {
    try {
      final response = await _apiClient.put(
        '$_baseUrl/',
        data: requestModel.toJson(),
      );
      return CompanyProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> uploadCompanyLogo(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // response ទទួលបានជាប្រភេទ Map<String, dynamic>
      final response = await _apiClient.post('$_baseUrl/logo', data: formData);

      // 🎯 កែប្រែត្រង់នេះ៖ ឆែកមើល key 'success' នៅក្នុង Map ជំនួសឱ្យ statusCode
      return response['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
