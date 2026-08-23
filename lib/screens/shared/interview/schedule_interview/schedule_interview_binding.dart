part of 'schedule_interview_view.dart';

class ScheduleInterviewViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleInterviewViewController());
  }
}
