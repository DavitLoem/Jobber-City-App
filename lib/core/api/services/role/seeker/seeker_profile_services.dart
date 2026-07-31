import 'package:dio/dio.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';

class SeekerProfileServices {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/seeker/profile';

  Future<bool> updateCoreProfile(SeekerCoreUpdateRequest data) async {
    try {
      final response = await _apiClient.put(
        '$_endpoint/core',
        data: data.toJson(),
      );

      return response['success'] == true;
    } catch (e) {
      rethrow;
    }
  }

  // មុខងារសម្រាប់ទាញយកទិន្នន័យ Profile មកបង្ហាញលើអេក្រង់
  Future<SeekerProfileResponse> getSeekerProfile() async {
    try {
      final response = await _apiClient.get('/seeker/profile/');

      // 🎯 បំប្លែង Map (JSON) ទៅជា Dart Model
      return SeekerProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> profileImage(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        // 🟢 កែត្រង់នេះ! ដូរពី "profile_image" ទៅជា "file" វិញ
        "file": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        '/seeker/profile/upload-image',
        data: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
