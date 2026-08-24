import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:jobber_city/core/api/network/api_client.dart';

class ApplicationService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> uploadCoverLetter(File file) async {
    try {
      String fileName = file.path.split('/').last;

      // រៀបចំទិន្នន័យជាទម្រង់ Form Data
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.post(
        '/seeker/cover-letter',
        data: formData,
      );

      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// 🎯 មុខងារសម្រាប់ដាក់ពាក្យការងារ
  Future<bool> applyForJob({
    required String jobId,
    String? coverLetter,
    String? coverLetterUrl,
    String? coverLetterFilename,
    String? resumeUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        '/seeker/jobs/$jobId/apply',
        data: {
          if (coverLetter != null && coverLetter.isNotEmpty)
            'cover_letter': coverLetter,

          // 🎯 បន្ថែម ២ បន្ទាត់នេះ ដើម្បីបញ្ជូន URL និង ឈ្មោះឯកសារ ទៅកាន់ Backend
          if (coverLetterUrl != null && coverLetterUrl.isNotEmpty)
            'cover_letter_url': coverLetterUrl,
          if (coverLetterFilename != null && coverLetterFilename.isNotEmpty)
            'cover_letter_filename': coverLetterFilename,

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
