import 'package:get/get.dart';
import 'package:jobber_city/screens/shared/interview/interview_list/interview_list_view.dart';

class InterviewListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InterviewListViewController(), fenix: false);
  }
}
