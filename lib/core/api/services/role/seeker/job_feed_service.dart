import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';

class JobFeedService {
  final ApiClient _apiClient = ApiClient();

  /// 🎯 ទាញយកបញ្ជីការងារថ្មីៗ (Recent Jobs)
  Future<List<JobFeedModel>> getRecentJobs({
    int page = 1,
    int limit = 10,
    String? categoryId,
  }) async {
    // 🎯 ត្រូវបញ្ជូន categoryId ទៅឱ្យ _fetchJobs
    return _fetchJobs('/seeker/jobs/recent', page, limit, categoryId);
  }

  /// 🎯 ទាញយកបញ្ជីការងារដែលប្រព័ន្ធណែនាំ (Recommended Jobs)
  Future<List<JobFeedModel>> getRecommendedJobs({
    int page = 1,
    int limit = 10,
  }) async {
    return _fetchJobs('/seeker/jobs/recommended', page, limit, null);
  }

  /// 🛠 អនុគមន៍ជំនួយ (Helper)
  Future<List<JobFeedModel>> _fetchJobs(
    String endpoint,
    int page,
    int limit,
    String? categoryId,
  ) async {
    try {
      // 🎯 រៀបចំ Query Parameters
      final Map<String, dynamic> query = {'page': page, 'limit': limit};

      // បើមាន categoryId (មានន័យថាគាត់អត់ចុច "All") ត្រូវបញ្ចូលវាទៅក្នុង API Request
      if (categoryId != null && categoryId.isNotEmpty) {
        query['category_id'] = categoryId;
      }

      final response = await _apiClient.get(
        endpoint,
        queryParameters: query, // បញ្ជូនទៅ Backend
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> dataList = response['data'];
        if (dataList.isNotEmpty) {
          debugPrint("🚨 API Response Check: ${dataList[0]['is_applied']}");
        }
        return dataList.map((json) => JobFeedModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load jobs.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
