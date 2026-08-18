part of 'setting_screen_view.dart';

class SettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingScreenViewController());
  }
}
