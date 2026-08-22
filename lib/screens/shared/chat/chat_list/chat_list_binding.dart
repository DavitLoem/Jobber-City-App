import 'package:get/get.dart';
import 'package:jobber_city/screens/shared/chat/chat_list/chat_list_view.dart';

class ChatListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatListViewController(), fenix: false);
  }
}
