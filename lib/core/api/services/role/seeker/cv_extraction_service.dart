import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/cv_extraction_model.dart';

class CvExtractionService {
  final ApiClient _apiClient = ApiClient();

  Future<CvExtractionResponseModel> uploadAndExtractCv(
    File file, {
    required CancelToken? cancelToken,
  }) async {
    try {
      // ១. រៀបចំទិន្នន័យឯកសារជាទម្រង់ FormData
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      // ២. បាញ់ Request ទៅកាន់ Endpoint ដែលយើងទើបកែនៅ Backend
      final response = await _apiClient.post(
        '/seeker/profile/upload-cv',
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      // ៣. ពិនិត្យលទ្ធផល និងបំប្លែងទិន្នន័យទៅជា Model
      if (response['success'] == true) {
        return CvExtractionResponseModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to analyze CV.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCv() async {
    try {
      final response = await _apiClient.delete('/seeker/profile/resume');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to delete CV.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
