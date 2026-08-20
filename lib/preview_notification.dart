import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/api/services/firebase_messaging_service.dart';

class NotificationTestView extends StatefulWidget {
  const NotificationTestView({super.key});

  @override
  State<NotificationTestView> createState() => _NotificationTestViewState();
}

class _NotificationTestViewState extends State<NotificationTestView> {
  String _token = "កំពុងទាញយក Token...";
  String _status = "កំពុងរង់ចាំ...";

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetToken();
  }

  Future<void> _requestPermissionAndGetToken() async {
    // ១. សុំសិទ្ធិពី Android (សំខាន់បំផុតសម្រាប់ Android 13+)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _token = token ?? "រកមិនឃើញ Token ទេ";
        _status = "ទទួលបានសិទ្ធិពេញលេញ ✅";
      });
    } else {
      setState(() {
        _token = "គ្មាន Token ទេ";
        _status = "អ្នកប្រើប្រាស់បដិសេធមិនឱ្យបង្ហាញសារ ❌";
      });
    }
  }

  // ២. សាកល្បងហៅ Local Notification ដោយមិនបាច់ពឹង Backend
  void _testLocalNotification() {
    // បង្កើត Data គំរូដើម្បីបញ្ឆោត Service របស់អ្នក
    const testMessage = RemoteMessage(
      notification: RemoteNotification(
        title: "តេស្ត Local Banner",
        body:
            "ប្រសិនបើអ្នកឃើញផ្ទាំងនេះ មានន័យថា Local Notification ដំណើរការល្អ!",
      ),
      data: {'related_id': 'test_123'},
    );

    // ហៅ Service របស់អ្នកមកបង្ហាញ
    FirebaseMessagingService.showLocalNotification(testMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM Test Page")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "ស្ថានភាព Permission:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _status,
              style: const TextStyle(color: Colors.blue, fontSize: 16),
            ),
            const SizedBox(height: 20),

            const Text(
              "FCM Token របស់អ្នក:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(_token),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text("Copy Token"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _token));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Copied!")));
              },
            ),

            const Divider(height: 40),

            const Text(
              "ជំហានតេស្ត៖",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  _testLocalNotification, // 🟢 ដក Comment កន្លែងហៅ Service ចេញសិនមុននឹង Run
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("១. តេស្ត Local Banner (ចុចទីនេះ)"),
            ),
            const SizedBox(height: 10),
            const Text(
              "២. យក Token ខាងលើទៅ Paste ក្នុង Firebase Console > Messaging > Send Test Message ដើម្បីតេស្តបាញ់ពី Firebase ផ្ទាល់។",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
