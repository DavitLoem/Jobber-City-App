part of 'category_screen_view.dart';

class CategoryScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryScreenViewController());
  }
}