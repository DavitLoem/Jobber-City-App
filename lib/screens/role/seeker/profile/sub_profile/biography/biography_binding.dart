part of 'biography_view.dart';

class BiographyViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BiographyViewController());
  }
}
