import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';

class JobService {
  final _apiClient = ApiClient();
  final endpoint = '/employer/jobs/';

  Future<JobSingleResponseModel> createJob(JobRequestModel jobData) async {
    try {
      final response = await _apiClient.post(endpoint, data: jobData.toJson());

      return JobSingleResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<JobListResponseModel> getJobs({
    String? status,
    String? searchKeyword,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // 🎯 រៀបចំ Query Parameters ដោយបញ្ចូល page និង limit តែម្តង
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (status != null &&
          status.isNotEmpty &&
          status.toLowerCase() != 'all') {
        queryParams['status'] = status.split(' ').first.toLowerCase();
      }

      if (searchKeyword != null && searchKeyword.trim().isNotEmpty) {
        queryParams['search'] = searchKeyword.trim();
      }

      final response = await _apiClient.get(
        endpoint,
        queryParameters: queryParams,
      );

      return JobListResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<JobSingleResponseModel> updateJob(
    String jobId,
    JobRequestModel jobData,
  ) async {
    try {
      final response = await _apiClient.put(
        '$endpoint$jobId',
        data: jobData.toJson(),
      );

      return JobSingleResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteJob(String jobId) async {
    try {
      final response = await _apiClient.delete('$endpoint$jobId');

      return response['success'] ?? true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateJobStatus(String jobId, String newStatus) async {
    try {
      final response = await _apiClient.patch(
        '$endpoint$jobId/status',
        data: {"status": newStatus},
      );

      return response['success'] ?? true;
    } catch (e) {
      rethrow;
    }
  }
}
