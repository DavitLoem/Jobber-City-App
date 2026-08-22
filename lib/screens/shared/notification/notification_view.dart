import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          onPressed: () => Get.back(),
        ),
        actions: [
          // 🟢 ប៊ូតុង Mark All As Read ស្តាប់តាម Global Controller
          Obx(() {
            if (controller.globalNotifController.unreadCount.value == 0) {
              return const SizedBox.shrink();
            }
            return IconButton(
              tooltip: "Mark all as read",
              icon: const Icon(
                LucideIcons.checkCheck,
                color: Color(0xFF4F7DF7),
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
            child: CircularProgressIndicator(color: Color(0xFF4F7DF7)),
          );
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: const Color(0xFF4F7DF7),
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
                        color: Color(0xFF4F7DF7),
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
                          // សម្រាប់ Employer
                          Get.toNamed(
                            AppRoutes.candidateDetail,
                            arguments: notif.relatedId,
                          );
                          break;
                        case 'status_update':
                          // សម្រាប់ Seeker
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bellOff, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No notifications yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll let you know when something happens.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
