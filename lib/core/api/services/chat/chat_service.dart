import 'package:jobber_city/core/api/network/api_client.dart';
import 'package:jobber_city/models/chat/chat_models.dart';

/// Wraps `/api/chat/*` (see `chat_router.py`). WebSocket (`ChatSocketService`)
/// is the primary real-time channel while a conversation screen is open —
/// this REST service covers everything else: listing the inbox, loading
/// message history, starting a new conversation, marking as read, and a
/// send-via-REST fallback for when the socket isn't connected.
class ChatService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/chat';

  /// Get-or-create the conversation with [otherUserId] (a seeker messaging
  /// an employer, or vice versa). Safe to call every time a "Message"
  /// button is tapped — the backend returns the existing thread if one
  /// already exists instead of creating a duplicate.
  Future<ChatConversation> startConversation({
    required String otherUserId,
    String? jobId,
  }) async {
    final response = await _apiClient.post(
      '$_endpoint/conversations',
      data: {
        'other_user_id': otherUserId,
        if (jobId != null) 'job_id': jobId,
      },
    );
    return ChatConversation.fromJson(response['data']);
  }

  Future<List<ChatConversation>> listConversations({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '$_endpoint/conversations',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response['data'] as List? ?? [];
    return data.map((e) => ChatConversation.fromJson(e)).toList();
  }

  /// Cursor-based pagination — pass [before] as the oldest message id
  /// currently loaded to fetch the next page further back in history.
  Future<({List<ChatMessage> messages, bool hasMore})> getMessages(
    String conversationId, {
    String? before,
    int limit = 30,
  }) async {
    final response = await _apiClient.get(
      '$_endpoint/conversations/$conversationId/messages',
      queryParameters: {
        'limit': limit,
        if (before != null) 'before': before,
      },
    );
    final data = response['data'] ?? {};
    final messages = (data['messages'] as List? ?? []).map((e) => ChatMessage.fromJson(e)).toList();
    return (messages: messages, hasMore: data['has_more'] == true);
  }

  Future<void> markAsRead(String conversationId) async {
    await _apiClient.post('$_endpoint/conversations/$conversationId/read');
  }

  /// Employer-only: browse EVERY seeker account in the system (not just
  /// ones with an existing conversation or job application) so a new chat
  /// can be started with anyone. Backed by `GET /api/employer/jobs/seekers`
  /// — kept in `ChatService` (rather than a separate service) since its
  /// only current use is as the entry point into starting a new chat.
  Future<({List<SeekerDirectoryItem> items, bool hasMore})> listAllSeekers({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/employer/jobs/seekers',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final data = response['data'] ?? {};
    final items = (data['items'] as List? ?? [])
        .map((e) => SeekerDirectoryItem.fromJson(e))
        .toList();
    return (items: items, hasMore: data['has_more'] == true);
  }

  /// Fallback path when the WebSocket isn't connected — same effect as a
  /// `send_message` WS event, just over plain HTTP.
  Future<ChatMessage> sendMessageRest({
    required String conversationId,
    required String content,
    String messageType = 'text',
    String? attachmentUrl,
    String? clientTempId,
  }) async {
    final response = await _apiClient.post(
      '$_endpoint/conversations/$conversationId/messages',
      data: {
        'content': content,
        'message_type': messageType,
        if (attachmentUrl != null) 'attachment_url': attachmentUrl,
        if (clientTempId != null) 'client_temp_id': clientTempId,
      },
    );
    return ChatMessage.fromJson(response['data']);
  }
}
