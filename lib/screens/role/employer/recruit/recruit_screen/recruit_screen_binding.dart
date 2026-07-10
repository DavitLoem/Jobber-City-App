part of 'recruit_screen_view.dart';

class RecruitScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecruitScreenViewController());
  }
}