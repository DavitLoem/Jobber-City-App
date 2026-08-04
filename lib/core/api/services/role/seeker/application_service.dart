import 'package:jobber_city/core/api/network/api_client.dart';

class ApplicationService {
  final ApiClient _apiClient = ApiClient();

  /// 🎯 មុខងារសម្រាប់ដាក់ពាក្យការងារ
  Future<bool> applyForJob({
    required String jobId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        '/seeker/jobs/$jobId/apply',
        data: {
          if (coverLetter != null && coverLetter.isNotEmpty)
            'cover_letter': coverLetter,
          if (resumeUrl != null && resumeUrl.isNotEmpty)
            'resume_url': resumeUrl,
        },
      );

      // ប្រសិនបើ success == true មានន័យថាដាក់ពាក្យជោគជ័យ
      return response['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
