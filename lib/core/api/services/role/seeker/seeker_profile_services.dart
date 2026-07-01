import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';

class SeekerProfileServices {
  final ApiClient _apiClient = ApiClient();

  // មុខងារសម្រាប់ Update ទិន្នន័យ Profile ទៅកាន់ Server
  Future<Map<String, dynamic>> updateSeekerProfile(
    SeekerProflieModel requestModel,
  ) async {
    try {
      final response = await _apiClient.put(
        '/seeker/profile/core',
        data: requestModel.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // មុខងារសម្រាប់ទាញយកទិន្នន័យ Profile មកបង្ហាញលើអេក្រង់
  Future<dynamic> getSeekerProfile() async {
    try {
      final response = await _apiClient.get('/seeker/profile/core');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
