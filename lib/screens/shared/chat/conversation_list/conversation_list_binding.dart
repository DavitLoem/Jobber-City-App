part of 'conversation_list_view.dart';

class ConversationListViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => ConversationListViewController());
   }
}