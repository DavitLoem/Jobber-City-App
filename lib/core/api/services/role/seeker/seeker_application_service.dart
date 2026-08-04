import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/my_application_model.dart';

class SeekerApplicationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MyApplicationModel>> getMyApplications({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/seeker/applications/me',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response['success'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((json) => MyApplicationModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
