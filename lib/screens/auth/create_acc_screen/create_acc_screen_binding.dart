part of 'create_acc_screen_view.dart';

class CreateAccScreenViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CreateAccScreenViewController());
   }
}