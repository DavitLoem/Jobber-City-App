import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'notification_employer_binding.dart';
part 'notification_employer_controller.dart';

class NotificationEmployerView
    extends GetView<NotificationEmployerViewController> {
  const NotificationEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.checkCheck, color: Color(0xFF4f7df7)),
            tooltip: 'Mark all as read',
            onPressed: () {
              // មុខងារ Mark all as read
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _buildDateHeader("Today"),
          _buildNotificationItem(
            icon: LucideIcons.userPlus,
            iconColor: Colors.green,
            title: "New Candidate Application",
            message:
                "Sok Dara has applied for the Senior Flutter Developer position.",
            time: "2 mins ago",
            isUnread: true,
          ),
          _buildNotificationItem(
            icon: LucideIcons.briefcase,
            iconColor: const Color(0xFF4f7df7),
            title: "Job Post Approved",
            message:
                "Your job post 'UI/UX Designer' is now live and visible to candidates.",
            time: "3 hours ago",
            isUnread: true,
          ),

          _buildDateHeader("Yesterday"),
          _buildNotificationItem(
            icon: LucideIcons.alertCircle,
            iconColor: Colors.orange,
            title: "Subscription Expiring Soon",
            message:
                "Your premium plan will expire in 3 days. Renew now to keep posting.",
            time: "1 day ago",
            isUnread: false,
          ),
          _buildNotificationItem(
            icon: LucideIcons.users,
            iconColor: Colors.purple,
            title: "Interview Reminder",
            message:
                "You have an interview scheduled with Chan Minea at 2:00 PM.",
            time: "1 day ago",
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      color: isUnread
          ? const Color(0xFFF0F4FF)
          : Colors.white, // ពណ៌ផ្ទៃខុសគ្នាសម្រាប់ Unread
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4f7df7),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: isUnread ? Colors.black87 : Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
