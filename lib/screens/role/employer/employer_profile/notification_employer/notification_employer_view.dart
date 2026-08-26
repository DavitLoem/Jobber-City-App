import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'notification_employer_binding.dart';
part 'notification_employer_controller.dart';

class NotificationEmployerView
    extends GetView<NotificationEmployerViewController> {
  const NotificationEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Icon
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.checkCheck,
              color: isDark ? Colors.blueAccent : AppColors.primary,
            ), // 🟢 Dynamic Action Icon
            tooltip: 'Mark all as read'.tr, // 🟢 Added .tr
            onPressed: () {
              // មុខងារ Mark all as read
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _buildDateHeader("Today".tr, isDark), // 🟢 Added .tr
          _buildNotificationItem(
            icon: LucideIcons.userPlus,
            iconColor: Colors.green,
            title: "New Candidate Application".tr, // 🟢 Added .tr
            message:
                "Sok Dara has applied for the Senior Flutter Developer position."
                    .tr, // 🟢 Added .tr
            time: "2 mins ago".tr, // 🟢 Added .tr
            isUnread: true,
            isDark: isDark,
          ),
          _buildNotificationItem(
            icon: LucideIcons.briefcase,
            iconColor: isDark ? Colors.blueAccent : AppColors.primary,
            title: "Job Post Approved".tr, // 🟢 Added .tr
            message:
                "Your job post 'UI/UX Designer' is now live and visible to candidates."
                    .tr, // 🟢 Added .tr
            time: "3 hours ago".tr, // 🟢 Added .tr
            isUnread: true,
            isDark: isDark,
          ),

          _buildDateHeader("Yesterday".tr, isDark), // 🟢 Added .tr
          _buildNotificationItem(
            icon: LucideIcons.alertCircle,
            iconColor: Colors.orange,
            title: "Subscription Expiring Soon".tr, // 🟢 Added .tr
            message:
                "Your premium plan will expire in 3 days. Renew now to keep posting."
                    .tr, // 🟢 Added .tr
            time: "1 day ago".tr, // 🟢 Added .tr
            isUnread: false,
            isDark: isDark,
          ),
          _buildNotificationItem(
            icon: LucideIcons.users,
            iconColor: Colors.purple,
            title: "Interview Reminder".tr, // 🟢 Added .tr
            message:
                "You have an interview scheduled with Chan Minea at 2:00 PM."
                    .tr, // 🟢 Added .tr
            time: "1 day ago".tr, // 🟢 Added .tr
            isUnread: false,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark
              ? AppColors.darkTextSecondary
              : Colors.grey.shade500, // 🟢 Dynamic Section Text
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
    required bool isDark,
  }) {
    return Container(
      color: isUnread
          ? (isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : const Color(0xFFF0F4FF)) // 🟢 Dynamic Unread Highlight
          : Colors.transparent, // 🟢 Dynamic Read Item BG
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: isDark ? 0.2 : 0.1,
              ), // 🟢 Dynamic Icon BG
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
                          color: isDark
                              ? Colors.white
                              : Colors.black87, // 🟢 Dynamic Title
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.blueAccent
                              : AppColors.primary, // 🟢 Dynamic Unread Dot
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: isUnread
                        ? (isDark ? Colors.white70 : Colors.black87)
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : Colors
                                    .grey
                                    .shade600), // 🟢 Dynamic Message Content
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : Colors.grey.shade500, // 🟢 Dynamic Timestamp
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
