import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';

class JobFeedService {
  final ApiClient _apiClient = ApiClient();

  // 🎯 ទាញយកបញ្ជីការងារថ្មីៗ (Recent Jobs)
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

  // 🛠 អនុគមន៍ជំនួយ (Helper)
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

  // 🎯 ទាញយកបញ្ជីការងារតាមរយៈការស្វែងរក (Search Jobs)
  Future<List<JobFeedModel>> searchJobs({
    String? keyword, // 🎯 ប្តូរមកជា Optional វិញ
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? industryId,
    double? minSalary,
    double? maxSalary,
    String? jobLevelId,
    String? employmentTypeId,
    String? provinceId,
  }) async {
    try {
      // 🎯 បង្កើត Map សម្រាប់ផ្ទុក Query Parameters ដើម្បិងាយស្រួលត្រងចោលតម្លៃ Null
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      // បន្ថែមលក្ខខណ្ឌចូលទៅក្នុង API តែនៅពេលដែលវាមានទិន្នន័យពិតប្រាកដ
      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParams['keyword'] = keyword.trim();
      }
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (industryId != null) queryParams['industry_id'] = industryId;
      if (minSalary != null) queryParams['min_salary'] = minSalary;
      if (maxSalary != null) queryParams['max_salary'] = maxSalary;
      if (jobLevelId != null) queryParams['job_level_id'] = jobLevelId;
      if (employmentTypeId != null) {
        queryParams['employment_type_id'] = employmentTypeId;
      }
      if (provinceId != null) queryParams['province_id'] = provinceId;

      final response = await _apiClient.get(
        '/seeker/jobs/search',
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> dataList = response['data'];
        return dataList.map((json) => JobFeedModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to search jobs.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
