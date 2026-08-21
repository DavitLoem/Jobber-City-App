class NotificationItemModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final String? relatedId;
  bool isRead;
  final DateTime? createdAt;

  NotificationItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      relatedId: json['related_id'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class NotificationListResponseModel {
  final List<NotificationItemModel> notifications;
  final int total;

  NotificationListResponseModel({
    required this.notifications,
    required this.total,
  });

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationListResponseModel(
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map((e) => NotificationItemModel.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}
