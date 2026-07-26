import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/job_recommended_model.dart';

class JobRecommendedServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<JobRecommendedModel>> getJobRecommended() async {
    try {
      final response = await _apiClient.get('/seeker/jobs/recommended');
      print('API Response type: ${response.runtimeType}');
      print('API Response: $response');

      if (response is List) {
        return response
            .map((json) => JobRecommendedModel.fromJson(json))
            .toList();
      } else if (response is Map && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => JobRecommendedModel.fromJson(json))
            .toList();
      }
      print('Response format not recognized');
      return [];
    } catch (e) {
      print('Error in getJobRecommended: $e');
      rethrow;
    }
  }
}
