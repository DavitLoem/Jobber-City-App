part of 'experience_view.dart';

class ExperienceViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => ExperienceViewController());
   }
}