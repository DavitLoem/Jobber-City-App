part of 'chat_room_view.dart';

class ChatRoomViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => ChatRoomViewController());
   }
}