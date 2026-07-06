import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/trainings_model.dart';

class TrainingsServices {
  final ApiClient _apiClient = ApiClient();

  // ប្រើប្រាស់ TraningsModel ឲ្យត្រូវនឹងឈ្មោះ Class ក្នុង Model របស់អ្នក
  Future<dynamic> addTraining(TraningsModel training) async {
    try {
      final response = await _apiClient.post(
        '/seeker/profile/trainings/', // 🟢 កុំភ្លេចសញ្ញា /
        data: training.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTrainings() async {
    try {
      final response = await _apiClient.get('/seeker/profile/trainings/');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
