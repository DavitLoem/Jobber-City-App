import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';

class ApplicantEmployerService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ApplicantModel>> getJobApplicants({
    // 🎯 ប្តូរពី List<dynamic> មក List<ApplicantModel>
    required String jobId,
    String status = 'all',
  }) async {
    try {
      final response = await _apiClient.get(
        '/employer/jobs/$jobId/applicants',
        queryParameters: {'status': status},
      );

      if (response['success'] == true && response['data'] != null) {
        // 🎯 បំប្លែងទិន្នន័យ JSON ដែលបានមកពី Backend ទៅជា Object របស់ ApplicantModel
        List<dynamic> dataList = response['data'];
        return dataList.map((json) => ApplicantModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching applicants: $e");
      rethrow;
    }
  }

  Future<bool> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/employer/jobs/applications/$applicationId/status',
        data: {
          'status': newStatus,
        }, // ត្រូវគ្នានឹង UpdateApplicationStatus payload របស់ FastAPI
      );

      return response['success'] == true;
    } catch (e) {
      debugPrint("Error updating application status: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSeekerProfile(String seekerUserId) async {
    try {
      final response = await _apiClient.get(
        '/employer/jobs/seekers/$seekerUserId/profile',
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;

        // ស្រដៀងគ្នាដែរ បើមាន Profile Model អាច Return ជា Model វិញ
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching seeker profile: $e");
      rethrow;
    }
  }
}
