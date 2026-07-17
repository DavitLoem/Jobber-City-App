part of 'new_job_view.dart';

class NewJobViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewJobViewController());
  }
}
