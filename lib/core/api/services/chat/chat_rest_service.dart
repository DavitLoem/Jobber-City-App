import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';

import '../../../../models/chat_model.dart';

class ChatRestService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/chat';

  Future<ChatConversation> startConversation({
    required String otherUserId,
    String? jobId,
  }) async {
    final response = await _apiClient.post(
      '$_endpoint/conversations',
      data: {
        'other_user_id': otherUserId,
        'job_id': ?jobId, // 🎯 កែ Syntax ឱ្យត្រូវតាមស្តង់ដារ Dart
      },
    );
    return ChatConversation.fromJson(response['data']);
  }

  Future<List<ChatConversation>> listConversations({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '$_endpoint/conversations',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response['data'] as List? ?? [];
    return data.map((e) => ChatConversation.fromJson(e)).toList();
  }

  Future<({List<ChatMessage> messages, bool hasMore})> getMessages(
    String conversationId, {
    String? before,
    int limit = 30,
  }) async {
    final response = await _apiClient.get(
      '$_endpoint/conversations/$conversationId/messages',
      queryParameters: {
        'limit': limit,
        'before': ?before, // 🎯 កែ Syntax
      },
    );
    final data = response['data'] ?? {};
    final messages = (data['messages'] as List? ?? [])
        .map((e) => ChatMessage.fromJson(e))
        .toList();
    return (messages: messages, hasMore: data['has_more'] == true);
  }

  Future<void> markAsRead(String conversationId) async {
    await _apiClient.post('$_endpoint/conversations/$conversationId/read');
  }

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
        'attachment_url': ?attachmentUrl,
        'client_temp_id': ?clientTempId,
      },
    );
    return ChatMessage.fromJson(response['data']);
  }

  Future<bool> registerDeviceToken(String fcmToken, String platform) async {
    try {
      final response = await _apiClient.post(
        '$_endpoint/device-tokens',
        data: {"fcm_token": fcmToken, "platform": platform},
      );
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMessage(
    String conversationId,
    String messageId,
    String type,
  ) async {
    try {
      final response = await _apiClient.delete(
        '$_endpoint/conversations/$conversationId/messages/$messageId?type=$type',
      );
      return response['success'] == true;
    } catch (e) {
      debugPrint("Error deleting message: $e");
      return false;
    }
  }
}
