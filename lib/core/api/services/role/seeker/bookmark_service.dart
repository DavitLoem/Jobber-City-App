import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/job_feed_model.dart';

class BookmarkService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> toggleBookmark(String jobId) async {
    try {
      final response = await _apiClient.post('/seeker/jobs/$jobId/bookmark');

      if (response['success'] == true && response['data'] != null) {
        // ត្រឡប់តម្លៃ is_saved ពី API មកវិញ (true គឺបាន Save, false គឺបាន Unsave)
        return response['data']['is_saved'] ?? false;
      } else {
        throw Exception(response['message'] ?? 'Failed to toggle bookmark.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🎯 ២. មុខងារសម្រាប់ទាញយកបញ្ជីការងារដែលបាន Save ទាំងអស់
  Future<List<JobFeedModel>> getSavedJobs({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/seeker/jobs/bookmarks/me',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> dataList = response['data'];

        // 🎯 ដំណោះស្រាយ៖ បង្ខំឱ្យ job.isSaved = true ជានិច្ចសម្រាប់បញ្ជីនេះ
        return dataList.map((json) {
          final job = JobFeedModel.fromJson(json);
          job.isSaved = true; // កំណត់តម្លៃនៅទីនេះផ្ទាល់
          return job;
        }).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load saved jobs.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
