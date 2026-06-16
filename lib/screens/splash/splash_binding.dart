part of 'splash_view.dart';

class SplashViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => SplashViewController());
   }
}