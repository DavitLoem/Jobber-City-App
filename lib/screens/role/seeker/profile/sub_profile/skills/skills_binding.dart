part of 'skills_view.dart';

class SkillsViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => SkillsViewController());
   }
}