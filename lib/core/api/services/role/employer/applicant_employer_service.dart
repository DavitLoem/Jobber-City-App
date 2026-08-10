import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/models/role/employer/job_dropdown_item_model.dart';

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

  /// 🎯 ទាញយកបញ្ជីការងារសម្រាប់បង្ហាញក្នុង Bottom Sheet
  Future<List<JobDropdownItemModel>> getJobDropdownList() async {
    try {
      final response = await _apiClient.get(
        '/employer/jobs/applications/dropdown',
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> dataList = response['data'];
        return dataList
            .map((json) => JobDropdownItemModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load job list.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateApplicationStatus({
    required String applicationId,
    required String newStatus,
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    try {
      // 🎯 បង្កើត Payload សម្រាប់បញ្ជូនទៅ Backend
      final Map<String, dynamic> payload = {'status': newStatus};

      // 🎯 បញ្ចូលទិន្នន័យបន្ថែម តែក្នុងករណីដែលវាមានតម្លៃប៉ុណ្ណោះ
      if (interviewSchedule != null) {
        payload['interview_schedule'] = interviewSchedule;
      }

      if (feedback != null && feedback.isNotEmpty) {
        payload['feedback'] = feedback;
      }

      final response = await _apiClient.patch(
        '/employer/jobs/applications/$applicationId/status',
        data: payload,
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
