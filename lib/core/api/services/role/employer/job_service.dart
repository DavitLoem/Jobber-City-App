import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';

class JobService {
  final _apiClient = ApiClient();
  final endpoint = '/employer/jobs/';

  Future<JobResponseModel> createJob(JobRequestModel jobData) async {
    try {
      final response = await _apiClient.post(endpoint, data: jobData.toJson());

      return JobResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
