part of 'home_employer_view.dart';

class HomeEmployerViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomeEmployerViewController());
   }
}