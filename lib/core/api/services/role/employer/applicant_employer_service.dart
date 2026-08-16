import 'package:flutter/foundation.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:jobber_city/models/role/employer/job_dropdown_item_model.dart';

import '../../../../../models/role/employer/applicant_status_summary_model.dart';

class ApplicantEmployerService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ApplicantModel>> getJobApplicants({
    required String jobId,
    String status = 'all',
    String? searchKeyword,
    String sortBy = 'newest',
    int page = 1,
    int limit = 20,
    bool isExport = false,
  }) async {
    try {
      // 🟢 ២. រៀបចំ Query Parameters បញ្ចូលគ្នា
      final Map<String, dynamic> queryParams = {
        'status': status,
        'sort_by': sortBy,
        'page': page.toString(),
        'limit': limit.toString(),
        'is_export': isExport.toString(),
      };

      // ប្រសិនបើមានវាយពាក្យស្វែងរក ទើបយើងដាក់វាចូលទៅ
      if (searchKeyword != null && searchKeyword.trim().isNotEmpty) {
        queryParams['search'] = searchKeyword.trim();
      }

      final response = await _apiClient.get(
        '/employer/jobs/$jobId/applicants',
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
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

  Future<ApplicantStatusSummaryModel?> getApplicantStatusSummary(
    String jobId,
  ) async {
    try {
      final response = await _apiClient.get(
        '/employer/jobs/$jobId/applicants/summary',
      );

      if (response['success'] == true && response['data'] != null) {
        return ApplicantStatusSummaryModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error fetching applicant summary: $e");
      // ត្រឡប់ null ដើម្បីកុំឱ្យធ្លាក់ App ពេល Network មានបញ្ហា
      return null;
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

  Future<bool> bulkUpdateApplicationStatus({
    required List<String> applicationIds,
    required String newStatus,
    Map<String, dynamic>? interviewSchedule,
    String? feedback,
  }) async {
    try {
      // 🎯 រៀបចំ Payload
      final Map<String, dynamic> payload = {
        'application_ids': applicationIds,
        'status': newStatus,
      };

      if (interviewSchedule != null) {
        payload['interview_schedule'] = interviewSchedule;
      }

      if (feedback != null && feedback.isNotEmpty) {
        payload['feedback'] = feedback;
      }

      // 🎯 បាញ់ PATCH Request ទៅកាន់ API
      final response = await _apiClient.patch(
        '/employer/jobs/applications/bulk-status',
        data:
            payload, // ប្រសិនបើអ្នកប្រើ http ធម្មតា កុំភ្លេច jsonEncode(payload)
      );

      return response['success'] == true;
    } catch (e) {
      debugPrint("❌ Error bulk updating application status: $e");
      return false;
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
