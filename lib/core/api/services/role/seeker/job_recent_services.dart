import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/job_recent_model.dart';

class JobRecentServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<JobRecentModel>> getJobRecent() async {
    try {
      final response = await _apiClient.get('/seeker/jobs/recent');
      print('API Response type: ${response.runtimeType}');
      print('API Response: $response');

      if (response is List) {
        return response.map((json) => JobRecentModel.fromJson(json)).toList();
      } else if (response is Map && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => JobRecentModel.fromJson(json))
            .toList();
      }
      print('Response format not recognized');
      return [];
    } catch (e) {
      print('Error in getJobRecent: $e');
      rethrow;
    }
  }
}
