part of 'post_job_screen_view.dart';

class PostJobScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostJobScreenViewController());
  }
}
