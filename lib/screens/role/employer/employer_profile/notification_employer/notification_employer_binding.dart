part of 'notification_employer_view.dart';

class NotificationEmployerViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => NotificationEmployerViewController());
   }
}