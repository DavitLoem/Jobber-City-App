part of 'job_detail_view.dart';

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobDetailController());
  }
}
