import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/educations_model.dart';

class EducationsServices {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> educations(EducationsModel model) async {
    try {
      final response = await _apiClient.post(
        '/seeker/profile/educations/',
        data: model.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getEducations() async {
    try {
      final response = await _apiClient.get('/seeker/profile/educations/');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
