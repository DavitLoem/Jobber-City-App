import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/interview/interview_models.dart';

/// Wraps `/api/interviews/*` (see `interview_router.py`) — online video
/// interview scheduling between an employer and a seeker. The actual call
/// happens on Jitsi Meet (`meet.jit.si`); this service only handles the
/// scheduling metadata and hands back the meeting URL to open.
class InterviewService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/interviews';

  Future<InterviewModel> scheduleInterview({
    required String seekerUserId,
    required DateTime scheduledAt,
    int durationMinutes = 30,
    String? jobId,
    String? applicationId,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      '$_endpoint/',
      data: {
        'seeker_user_id': seekerUserId,
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'duration_minutes': durationMinutes,
        if (jobId != null) 'job_id': jobId,
        if (applicationId != null) 'application_id': applicationId,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );
    return InterviewModel.fromJson(response['data']);
  }

  Future<List<InterviewModel>> listInterviews({String status = 'all', int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '$_endpoint/',
      queryParameters: {'status': status, 'page': page, 'limit': limit},
    );
    final data = response['data'] as List? ?? [];
    return data.map((e) => InterviewModel.fromJson(e)).toList();
  }

  Future<InterviewModel> getInterview(String interviewId) async {
    final response = await _apiClient.get('$_endpoint/$interviewId');
    return InterviewModel.fromJson(response['data']);
  }

  Future<InterviewModel> rescheduleInterview(
    String interviewId, {
    required DateTime scheduledAt,
    int? durationMinutes,
  }) async {
    final response = await _apiClient.patch(
      '$_endpoint/$interviewId/reschedule',
      data: {
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
        if (durationMinutes != null) 'duration_minutes': durationMinutes,
      },
    );
    return InterviewModel.fromJson(response['data']);
  }

  Future<InterviewModel> cancelInterview(String interviewId, {String? reason}) async {
    final response = await _apiClient.post(
      '$_endpoint/$interviewId/cancel',
      data: {if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim()},
    );
    return InterviewModel.fromJson(response['data']);
  }

  Future<JoinInterviewResult> joinInterview(String interviewId) async {
    final response = await _apiClient.post('$_endpoint/$interviewId/join');
    return JoinInterviewResult.fromJson(response['data']);
  }

  Future<InterviewModel> completeInterview(String interviewId) async {
    final response = await _apiClient.post('$_endpoint/$interviewId/complete');
    return InterviewModel.fromJson(response['data']);
  }
}
