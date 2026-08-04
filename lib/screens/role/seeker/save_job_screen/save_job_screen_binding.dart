part of 'save_job_screen_view.dart';

class SaveJobScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaveJobScreenViewController());
  }
}