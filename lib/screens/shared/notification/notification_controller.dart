part of 'notification_view.dart';

class NotificationViewController extends GetxController {
  final NotificationApiService _service = NotificationApiService();

  final NotificationController globalNotifController =
      Get.find<NotificationController>();

  // State សម្រាប់បញ្ជី Notification
  final notifications = <NotificationItemModel>[].obs;
  final isLoading = false.obs;
  final isLoadMore = false.obs;
  final hasMore = true.obs;
  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(isRefresh: true);
  }

  // 🎯 ទាញយកបញ្ជីសារ
  Future<void> fetchNotifications({bool isRefresh = true}) async {
    if (isRefresh) {
      isLoading.value = true;
      hasMore.value = true;
      notifications.clear();
    }

    if (!hasMore.value) return;

    try {
      final skip = notifications.length;
      final result = await _service.getNotifications(limit: limit, skip: skip);

      if (result != null) {
        if (isRefresh) {
          notifications.assignAll(result.notifications);
        } else {
          notifications.addAll(result.notifications);
        }

        // ឆែកមើលថាអស់ទិន្នន័យឬនៅ
        if (result.notifications.length < limit) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching notifications: $e");
    } finally {
      if (isRefresh) {
        isLoading.value = false;
      }
    }
  }

  // 🎯 មុខងារ Load More
  Future<void> loadMoreNotifications() async {
    if (isLoadMore.value || !hasMore.value) return;
    isLoadMore.value = true;
    await fetchNotifications(isRefresh: false);
    isLoadMore.value = false;
  }

  // 🎯 ពេលចុច Mark All As Read
  Future<void> markAllAsRead() async {
    if (globalNotifController.unreadCount.value == 0) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _service.markAllAsRead();

    Get.back(); // បិទ Loading

    if (success) {
      // ១. Reset លើកណ្តឹង
      globalNotifController.resetUnreadCount();

      // ២. Update UI ក្នុង List ឱ្យបាត់ពណ៌ Highlight
      for (var notif in notifications) {
        notif.isRead = true;
      }
      notifications.refresh();
    }
  }

  // 🎯 ពេលចុចអានសារនៅលើកាតនីមួយៗ
  void markSingleAsRead(NotificationItemModel notif) {
    if (!notif.isRead) {
      // 1. Update UI ភ្លាមៗ (Optimistic Update)
      notif.isRead = true;
      notifications.refresh();
      globalNotifController.decrementUnread();

      // 2. បាញ់ API ទៅ Backend ស្ងាត់ៗពីក្រោយ (Background)
      _service.markSingleAsRead(notif.id);
    }
  }
}
