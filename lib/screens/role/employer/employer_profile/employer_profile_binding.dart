part of 'employer_profile_view.dart';

class EmployerProfileViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => EmployerProfileViewController());
   }
}