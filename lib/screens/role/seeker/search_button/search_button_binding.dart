import 'package:get/get.dart';
import 'search_button_controller.dart';

class SearchButtonViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchButtonViewController());
  }
}
