part of 'change_password_view.dart';

class ChangePasswordViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => ChangePasswordViewController());
   }
}