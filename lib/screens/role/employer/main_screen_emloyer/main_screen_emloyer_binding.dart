import 'package:get/get.dart';
import 'package:jobber_city/screens/role/employer/candidates/candidates_view.dart';
import 'package:jobber_city/screens/role/employer/employer_profile/employer_profile_view.dart';
import 'package:jobber_city/screens/role/employer/main_screen_emloyer/main_screen_emloyer_controller.dart';
import 'package:jobber_city/screens/role/employer/my_job/my_job_view.dart';
import 'package:jobber_city/screens/role/seeker/home_seeker/home_seeker_view.dart';

import '../../../shared/chat/conversation_list/conversation_list_view.dart';

class MainScreenEmloyerBinding extends Bindings {
  @override
  void dependencies() {
    // សម្រាប់ Bottom Bar (Main)
    Get.lazyPut(() => MainScreenEmloyerController());

    Get.lazyPut(() => HomeSeekerViewController(), fenix: true);
    Get.lazyPut(() => MyJobViewController(), fenix: true);
    Get.lazyPut(() => CandidatesViewController(), fenix: true);
    Get.lazyPut(() => ConversationListViewController(), fenix: true);
    Get.lazyPut(() => EmployerProfileViewController(), fenix: true);
  }
}
