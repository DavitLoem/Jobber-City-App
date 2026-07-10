part of 'detail_post_screen_view.dart';

class DetailPostScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailPostScreenViewController());
  }
}