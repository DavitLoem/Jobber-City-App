import 'package:get/get.dart';
import 'package:jobber_city/screens/shared/chat/chat_thread/chat_thread_view.dart';

class ChatThreadViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatThreadViewController(), fenix: false);
  }
}
