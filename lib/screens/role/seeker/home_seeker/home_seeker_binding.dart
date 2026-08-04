part of 'home_seeker_view.dart';

class HomeSeekerViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomeSeekerViewController());
   }
}