part of 'edit_profile_employer_view.dart';

class EditProfileEmployerViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => EditProfileEmployerViewController());
   }
}