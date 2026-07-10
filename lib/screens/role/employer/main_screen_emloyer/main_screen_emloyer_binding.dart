import 'package:get/get.dart';
import 'package:jobber_city/screens/role/employer/home_employer/home_employer_view.dart';
import 'package:jobber_city/screens/role/employer/recruit/post_job_screen/post_job_screen_view.dart';
import 'package:jobber_city/screens/role/employer/company_profile/company_profile_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:jobber_city/screens/role/employer/recruit/recruit_screen/recruit_screen_view.dart';

class MainScreenEmloyerBinding extends Bindings {
  @override
  void dependencies() {
    // សម្រាប់ Bottom Bar (Main)
    Get.lazyPut(() => MainScreenEmloyerController());

    // សម្រាប់ Tab ទី១ (Home)
    Get.lazyPut(() => HomeEmployerViewController());

    // សម្រាប់ Tab ទី២ (Post Job)
    Get.lazyPut(() => RecruitScreenViewController());

    // សម្រាប់ Tab ទី៣ (Company Profile)
    Get.lazyPut(() => CompanyProfileViewController());
  }
}
