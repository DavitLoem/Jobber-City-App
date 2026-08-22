part of 'cv_generator_view.dart';

class CvGeneratorViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CvGeneratorViewController());
  }
}
