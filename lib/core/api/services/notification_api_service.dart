import 'package:flutter/material.dart';
import 'package:jobber_city/core/api/network/api_client.dart';

import '../../../models/notification_model.dart';

class NotificationApiService {
  final ApiClient _apiClient = ApiClient();

  // ១. ទាញយកចំនួនសារមិនទាន់អាន
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get('/notifications/unread-count');
      if (response != null && response['data'] != null) {
        return response['data']['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('❌ Error fetching unread count: $e');
      return 0;
    }
  }

  // ២. ទាញយកបញ្ជី Notification ទាំងអស់ (មាន Pagination)
  Future<NotificationListResponseModel?> getNotifications({
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/notifications/',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      if (response != null && response['data'] != null) {
        return NotificationListResponseModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      return null;
    }
  }

  // ៣. ប្តូរស្ថានភាពទៅជាបានអានទាំងអស់
  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiClient.put('/notifications/mark-all-read');
      if (response != null && response['data'] != null) {
        return response['data'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error marking notifications as read: $e');
      return false;
    }
  }

  // ៤. ប្តូរស្ថានភាពសារតែមួយទៅជាបានអាន
  Future<bool> markSingleAsRead(String notificationId) async {
    try {
      final response = await _apiClient.put(
        '/notifications/$notificationId/read',
      );
      if (response != null && response['data'] != null) {
        return response['data'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error marking single notification as read: $e');
      return false;
    }
  }

  // ៥. បញ្ជូន FCM Token ទៅកាន់ Backend
  Future<bool> updateFcmToken(String fcmToken) async {
    try {
      final response = await _apiClient.post(
        '/notifications/fcm-token',
        data: {'fcm_token': fcmToken},
      );
      if (response != null && response['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating FCM token: $e');
      return false;
    }
  }
}
