import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/location_model.dart';

class LocationServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<LocationModel>> getLocation() async {
    final response = await _apiClient.get('/locations/provinces');
    try {
      if (response != null) {
        if (response is List) {
          return response.map((json) => LocationModel.fromJson(json)).toList();
        } else if (response is Map && response['data'] is List) {
          return (response['data'] as List)
              .map((json) => LocationModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Service Error fetching locations: $e');
      rethrow;
    }
  }
}
