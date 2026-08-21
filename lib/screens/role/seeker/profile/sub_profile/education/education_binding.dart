part of 'education_view.dart';

class EducationViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => EducationViewController());
   }
}