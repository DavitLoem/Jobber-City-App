import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';

class CompanyLogoServices {
  final ApiClient _apiClient = ApiClient();

  /// Upload a company logo from a local file path (e.g. from image_picker).
  ///
  /// Two bugs fixed vs the previous version:
  ///  1. Field name changed  "logo" → "file"  (matches FastAPI param)
  ///  2. Reads bytes first with File.readAsBytes() then uses
  ///     MultipartFile.fromBytes() — avoids PathNotFoundException when
  ///     image_picker returns a short-lived Android cache path.
  Future<Map<String, dynamic>> uploadLogo(String filePath) async {
    try {
      if (filePath.isEmpty) {
        throw Exception('File path is empty — no logo selected.');
      }

      // ✅ Read bytes BEFORE building FormData.
      //    On Android, image_picker sometimes returns a temp path that gets
      //    cleaned up. Reading bytes immediately keeps them in memory safely.
      final bytes = await File(filePath).readAsBytes();
      final filename = filePath.split('/').last;

      final formData = FormData.fromMap({
        // ✅ Field name must be "file" — matches API: (file: UploadFile = File(...))
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });

      debugPrint('📤 Uploading logo: $filename (${bytes.length} bytes)');

      final response = await _apiClient.post(
        '/employer/company-profile/logo',
        data: formData,
      );

      debugPrint('✅ Logo upload success: $response');
      return response as Map<String, dynamic>;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      debugPrint('❌ Logo upload DioException [$status]: $body');

      String message = 'Logo upload failed';
      if (body is Map) {
        message =
            body['message']?.toString() ??
            body['detail']?.toString() ??
            message;
      }
      throw Exception(message);
    } catch (e) {
      debugPrint('❌ Logo upload error: $e');
      rethrow;
    }
  }
}
