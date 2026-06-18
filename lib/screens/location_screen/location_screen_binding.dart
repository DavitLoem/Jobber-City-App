part of 'location_screen_view.dart';

class LocationScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationScreenController());
  }
}
