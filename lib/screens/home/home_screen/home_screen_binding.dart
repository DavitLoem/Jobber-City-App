part of 'home_screen_view.dart';

class HomeScreenViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomeScreenViewController());
   }
}