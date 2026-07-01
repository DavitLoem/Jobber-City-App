import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/company_model.dart';
import 'package:dio/dio.dart';

class CompanyServices {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> companyProfile(
    CompanyProfileModel requestModel,
  ) async {
    try {
      final response = await _apiClient.post(
        '/employer/company-profile/',
        data: requestModel.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> companyLogoUpload(String filePath) async {
    try {
      // 🟢 ការបំប្លែងទៅជា FormData គឺត្រូវធ្វើនៅក្នុង Service នេះឯង
      FormData formData = FormData.fromMap({
        // ឈ្មោះ "logo" នេះត្រូវតែដូចបេះបិទទៅនឹងអថេរក្នុង FastAPI: (logo: UploadFile = File(...))
        "logo": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        '/employer/company-profile/logo',
        data: formData, // បញ្ជូន FormData ទៅកាន់ FastAPI
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
