import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart'; // 🟢 បន្ថែម Get សម្រាប់ Routing

// ១. អនុគមន៍ Background ត្រូវតែនៅក្រៅ Class (Top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📥 Handling a background message: ${message.messageId}");
}

class FirebaseMessagingService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // ២. ចុះឈ្មោះ Background Handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ៣. រៀបចំ Local Notification សម្រាប់បង្ហាញពេល Foreground
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 🟢 [ចំណុចកែប្រែ]៖ ប្រើ Positional arguments និងបន្ថែម onDidReceiveNotificationResponse
    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 🎯 អនុគមន៍នេះនឹងដើរ នៅពេលគេចុចលើផ្ទាំង Banner ខណៈពេល App កំពុងបើក
        debugPrint("👆 User tapped on local notification");

        // លោតទៅកាន់ទំព័រ Notification (សូមប្តូរទៅតាម Route ជាក់ស្តែងរបស់អ្នក)
        Get.toNamed('/notification');
      },
    );

    // ៤. បង្កើត Notification Channel សម្រាប់ Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // ៥. អនុគមន៍សម្រាប់ហៅបញ្ចេញ Banner ពេល App កំពុងបើក (Foreground)
  static void showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // 🟢 [ចំណុចកែប្រែ]៖ ប្រើ Positional arguments ឱ្យត្រូវស្តង់ដារ package និងបន្ថែម payload
      _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        // 🟢 បញ្ជូនទិន្នន័យ (Data) ទៅកាន់ onDidReceiveNotificationResponse ខាងលើ
        payload: message.data['related_id'] ?? 'general',
      );
    }
  }
}
