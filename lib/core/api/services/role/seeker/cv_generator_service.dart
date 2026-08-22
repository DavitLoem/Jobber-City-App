import 'package:dio/dio.dart';
import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/seeker/cv_generator_model.dart';

/// Wraps `/api/seeker/cv/*` (see `cv_router.py`) — turns the seeker's saved
/// profile (experience, education, skills, etc.) into a polished PDF resume
/// using one of the backend's Jinja2/WeasyPrint templates. Distinct from
/// `cv_extraction_service.dart`, which goes the OTHER direction (upload an
/// existing PDF and let AI extract structured data from it).
class CvGeneratorService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/seeker/cv';

  Future<List<CvTemplateModel>> listTemplates() async {
    final response = await _apiClient.get('$_endpoint/templates');
    final data = response['data'] as List? ?? [];
    return data.map((e) => CvTemplateModel.fromJson(e)).toList();
  }

  Future<GeneratedCvModel> generateCv(String templateId) async {
    // 🎯 Rendering the PDF (WeasyPrint) + uploading it to Cloudinary can
    // take noticeably longer than a typical JSON request — give this one
    // call more room than the app's default 30s so a slow first render
    // doesn't surface as a false "connection timeout" error.
    final response = await _apiClient.post(
      '$_endpoint/generate',
      data: {'template_id': templateId},
      options: Options(receiveTimeout: const Duration(seconds: 60)),
    );
    return GeneratedCvModel.fromJson(response['data']);
  }

  Future<CurrentCvModel> getCurrentCv() async {
    final response = await _apiClient.get('$_endpoint/current');
    return CurrentCvModel.fromJson(response['data'] ?? {});
  }
}
