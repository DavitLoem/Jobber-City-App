import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/api_response_model.dart';

import '../../../../../models/role/seeker/profile_model.dart';

class ProfileCrudService {
  final ApiClient _apiClient = ApiClient();

  final String _expUrl = '/seeker/profile/experiences/';
  final String _eduUrl = '/seeker/profile/educations/';
  final String _trainUrl = '/seeker/profile/trainings/';
  final String _langUrl = '/seeker/profile/languages/';

  // =========================================
  // 📍 EXPERIENCES CRUD
  // =========================================
  Future<ApiResponse<ExperienceModel>> addExperience(
    ExperienceModel data,
  ) async {
    try {
      final response = await _apiClient.post(_expUrl, data: data.toJson());
      return ApiResponse.fromJson(
        response,
        (json) => ExperienceModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<ExperienceModel>> getExperience(String id) async {
    try {
      final response = await _apiClient.get('$_expUrl$id');
      return ApiResponse.fromJson(
        response,
        (json) => ExperienceModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<ExperienceModel>> updateExperience(
    String id,
    ExperienceModel data,
  ) async {
    try {
      final response = await _apiClient.put('$_expUrl$id', data: data.toJson());
      return ApiResponse.fromJson(
        response,
        (json) => ExperienceModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> deleteExperience(String id) async {
    try {
      final response = await _apiClient.delete('$_expUrl$id');
      return ApiResponse.fromJson(response, (json) => json);
    } catch (e) {
      rethrow;
    }
  }

  // =========================================
  // 📍 EDUCATIONS CRUD
  // =========================================
  Future<ApiResponse<EducationModel>> addEducation(EducationModel data) async {
    final response = await _apiClient.post(_eduUrl, data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => EducationModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<EducationModel>> getEducation(String id) async {
    final response = await _apiClient.get('$_eduUrl$id');
    return ApiResponse.fromJson(
      response,
      (json) => EducationModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<EducationModel>> updateEducation(
    String id,
    EducationModel data,
  ) async {
    final response = await _apiClient.put('$_eduUrl$id', data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => EducationModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> deleteEducation(String id) async {
    final response = await _apiClient.delete('$_eduUrl$id');
    return ApiResponse.fromJson(response, (json) => json);
  }

  // =========================================
  // 📍 TRAININGS CRUD
  // =========================================
  Future<ApiResponse<TrainingModel>> addTraining(TrainingModel data) async {
    final response = await _apiClient.post(_trainUrl, data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => TrainingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<TrainingModel>> getTraining(String id) async {
    final response = await _apiClient.get('$_trainUrl$id');
    return ApiResponse.fromJson(
      response,
      (json) => TrainingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<TrainingModel>> updateTraining(
    String id,
    TrainingModel data,
  ) async {
    final response = await _apiClient.put('$_trainUrl$id', data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => TrainingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> deleteTraining(String id) async {
    final response = await _apiClient.delete('$_trainUrl$id');
    return ApiResponse.fromJson(response, (json) => json);
  }

  // =========================================
  // 📍 LANGUAGES CRUD
  // =========================================
  Future<ApiResponse<LanguageModel>> addLanguage(LanguageModel data) async {
    final response = await _apiClient.post(_langUrl, data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => LanguageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<LanguageModel>> getLanguage(String id) async {
    final response = await _apiClient.get('$_langUrl$id');
    return ApiResponse.fromJson(
      response,
      (json) => LanguageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<LanguageModel>> updateLanguage(
    String id,
    LanguageModel data,
  ) async {
    final response = await _apiClient.put('$_langUrl$id', data: data.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => LanguageModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> deleteLanguage(String id) async {
    final response = await _apiClient.delete('$_langUrl$id');
    return ApiResponse.fromJson(response, (json) => json);
  }
}
