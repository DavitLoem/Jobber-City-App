import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/routes/app_routes.dart';
import 'package:jobber_city/screens/shared/notification/widgets/notification_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../controllers/notification_controller.dart';
import '../../../core/api/services/notification_api_service.dart';
import '../../../models/notification_model.dart';

part 'notification_binding.dart';
part 'notification_controller.dart';

class NotificationView extends GetView<NotificationViewController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifications".tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Text
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ), // 🟢 Dynamic Icon
          onPressed: () => Get.back(),
        ),
        actions: [
          // 🟢 ប៊ូតុង Mark All As Read ស្តាប់តាម Global Controller
          Obx(() {
            if (controller.globalNotifController.unreadCount.value == 0) {
              return const SizedBox.shrink();
            }
            return IconButton(
              tooltip: "Mark all as read".tr, // 🟢 Added .tr
              icon: Icon(
                LucideIcons.checkCheck,
                color: isDark
                    ? Colors.blueAccent
                    : AppColors.primary, // 🟢 Dynamic Icon
              ),
              onPressed: () {
                controller.markAllAsRead();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState(isDark); // 🟢 Passed Theme State
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.fetchNotifications(isRefresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoadMore.value &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 50) {
                controller.loadMoreNotifications();
              }
              return false;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount:
                  controller.notifications.length +
                  (controller.isLoadMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                final notif = controller.notifications[index];

                return NotificationCard(
                  notification: notif,
                  onTap: () {
                    // ១. សម្គាល់ថាបានអាន
                    controller.markSingleAsRead(notif);

                    // ២. Routing ទៅតាម Role របស់អ្នកប្រើប្រាស់
                    if (notif.relatedId != null) {
                      switch (notif.type.toLowerCase()) {
                        case 'new_application':
                          Get.toNamed(
                            AppRoutes.candidateDetail,
                            arguments: notif.relatedId,
                          );
                          break;
                        case 'status_update':
                          Get.toNamed(
                            AppRoutes.applicationDetail,
                            arguments: notif.relatedId,
                          );
                          break;
                      }
                    }
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.bellOff,
            size: 60,
            color: isDark ? AppColors.darkIconSecondary : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "No notifications yet".tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade600, // 🟢 Dynamic Text
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll let you know when something happens.".tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextTertiary : Colors.grey.shade500,
            ), // 🟢 Dynamic Text
          ),
        ],
      ),
    );
  }
}
