import 'package:get/get.dart';
import 'package:jobber_city/screens/shared/interview/interview_detail/interview_detail_view.dart';

class InterviewDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InterviewDetailViewController(), fenix: false);
  }
}
