import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../core/api/services/firebase_messaging_service.dart';
import '../core/api/services/notification_api_service.dart';
import '../routes/app_routes.dart';

class NotificationController extends GetxController {
  final NotificationApiService _service = NotificationApiService();

  // 🟢 State សម្រាប់ចំណុចក្រហមលើកណ្តឹង
  final unreadCount = 0.obs;
  bool get hasUnread => unreadCount.value > 0;

  @override
  void onInit() {
    super.onInit();
    // _startPolling();
    fetchUnreadCount();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      // ១. ស្នើសុំ Permission និងផ្ញើ Token ទៅ Backend (ដូចជំហានទី២ដែលយើងបានធ្វើ)
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await _service.updateFcmToken(token);
        }
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          _service.updateFcmToken(newToken);
        });

        // 🟢 ២. ចាប់ផ្តើម Initialize Local Notification
        await FirebaseMessagingService.initialize();

        // 🟢 ៣. ស្ថានភាព៖ ពេលកំពុងបើក App លេង (Foreground)
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // បញ្ចេញផ្ទាំង Banner
          FirebaseMessagingService.showLocalNotification(message);

          // 🎯 Update ចំណុចក្រហមលើកណ្តឹងភ្លាមៗ
          fetchUnreadCount();
        });

        // 🟢 ៤. ស្ថានភាព៖ ពេលចុចលើ Notification ខណៈពេល App កំពុងលាក់ក្នុង Background
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleNotificationClick(message);
        });

        // 🟢 ៥. ស្ថានភាព៖ ពេលចុចលើ Notification ខណៈពេល App ត្រូវបានបិទឈឹង (Terminated)
        FirebaseMessaging.instance.getInitialMessage().then((
          RemoteMessage? message,
        ) {
          if (message != null) {
            // ដាក់ Delay បន្តិចឱ្យ App ដើរចប់សិន ទើបបញ្ជូន Route
            Future.delayed(const Duration(milliseconds: 500), () {
              _handleNotificationClick(message);
            });
          }
        });
      }
    } catch (e) {
      // handle error
    }
  }

  void _handleNotificationClick(RemoteMessage message) {
    // យើងអាចទាញយក Data ពី Backend បាញ់មក (ឧ. type នៃការជូនដំណឹង)
    // សម្រាប់ពេលនេះ យើងឱ្យវាលោតទៅទំព័រ Notification រួមសិន
    Get.toNamed(AppRoutes.notification);
  }

  // 🎯 ទាញយកចំនួនសារមិនទាន់អានពី API
  Future<void> fetchUnreadCount() async {
    final count = await _service.getUnreadCount();
    unreadCount.value = count;
  }

  // 🎯 ហៅពេលចុច Mark All As Read ដើម្បីទម្លាក់លេខទៅ ០ វិញ
  void resetUnreadCount() {
    unreadCount.value = 0;
  }

  // 🎯 ហៅពេលចុចអានសារម្តងមួយៗ ដើម្បីកាត់បន្ថយលេខម្តង ១
  void decrementUnread() {
    if (unreadCount.value > 0) {
      unreadCount.value--;
    }
  }
}
