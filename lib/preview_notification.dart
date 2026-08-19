import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// ==========================================
// 🟢 ទំព័រគោល (Static View)
// ==========================================
class NotificationPreview extends StatelessWidget {
  const NotificationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទិន្នន័យសិប្បនិម្មិត (Mock Data) សម្រាប់មើល Preview
    final List<Map<String, dynamic>> mockNotifications = [
      {
        "id": "1",
        "title": "New Applicant! 🎉",
        "message": "Alexandra Chen has applied for Senior Product Designer.",
        "type": "new_application",
        "is_read": false,
        "time": "2m ago",
      },
      {
        "id": "2",
        "title": "Application Reviewed",
        "message":
            "Your application for Frontend Developer is currently under review by the HR team.",
        "type": "status_update",
        "is_read": true,
        "time": "5h ago",
      },
      {
        "id": "3",
        "title": "Account Verified",
        "message":
            "Your employer profile has been successfully verified. You can now post jobs.",
        "type": "system_alert",
        "is_read": false,
        "time": "1d ago",
      },
      {
        "id": "4",
        "title": "New Applicant! 🎉",
        "message": "Marcus Johnson has applied for Full Stack Engineer.",
        "type": "new_application",
        "is_read": true,
        "time": "2d ago",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E293B)),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            icon: const Icon(LucideIcons.checkCheck, color: Color(0xFF4F7DF7)),
            onPressed: () {
              debugPrint("Mark all as read clicked");
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notif = mockNotifications[index];
          return StaticNotificationCard(
            title: notif["title"],
            message: notif["message"],
            type: notif["type"],
            isRead: notif["is_read"],
            timeStr: notif["time"],
            onTap: () {
              debugPrint("Clicked on notification: ${notif["id"]}");
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// 🟢 កាត (Static Card)
// ==========================================
class StaticNotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String timeStr;
  final VoidCallback onTap;

  const StaticNotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.timeStr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 កំណត់ពណ៌ និង Icon ទៅតាមប្រភេទ (Type)
    Color iconBgColor = const Color(0xFFF1F5F9);
    Color iconColor = const Color(0xFF64748B);
    IconData iconData = LucideIcons.bell;

    switch (type.toLowerCase()) {
      case 'new_application':
        iconBgColor = const Color(0xFFEEF2FF);
        iconColor = const Color(0xFF4F7DF7);
        iconData = LucideIcons.briefcase;
        break;
      case 'status_update':
        iconBgColor = const Color(0xFFFFFBEB);
        iconColor = const Color(0xFFD97706);
        iconData = LucideIcons.refreshCcw;
        break;
      case 'system_alert':
        iconBgColor = const Color(0xFFFEF2F2);
        iconColor = const Color(0xFFEF4444);
        iconData = LucideIcons.alertCircle;
        break;
    }

    // 🎨 បើមិនទាន់អាន ឱ្យមាន Background ពណ៌ខៀវស្រាលៗ
    final bgColor = isRead
        ? Colors.white
        : const Color(0xFF4F7DF7).withValues(alpha: 0.05);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ផ្នែក Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),

            // ផ្នែកអក្សរ (Text)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      // 🔴 ចំណុចក្រហមសម្រាប់សារមិនទាន់អាន
                      if (!isRead)
                        Container(
                          margin: const EdgeInsets.only(top: 4, left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4F7DF7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isRead
                          ? Colors.grey.shade600
                          : Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
