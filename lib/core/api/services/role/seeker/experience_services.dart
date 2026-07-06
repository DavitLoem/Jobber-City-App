import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/experience_model.dart'; // ត្រូវប្រាកដថា Path ត្រឹមត្រូវ

class ExperienceServices {
  final ApiClient _apiClient = ApiClient();

  // 🟢 មុខងារបញ្ជូនទិន្នន័យថ្មីទៅកាន់ Server (ប្រើ POST)
  Future<dynamic> addExperience(ExperienceModel model) async {
    try {
      final response = await _apiClient.post(
        '/seeker/profile/experiences/',
        data: model.toJson(), // បញ្ជូនជា JSON
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // មុខងារទាញយកទិន្នន័យ (ប្រើ GET)
  Future<dynamic> getExperiences() async {
    try {
      final response = await _apiClient.get('/seeker/profile/experiences/');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
