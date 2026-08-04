part of 'educations_screen_view.dart';

class EducationsScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    // លុប Controller ចាស់ចោល ហើយបង្កើតថ្មី ដើម្បីអោយវាហៅ onInit() ទាញទិន្នន័យសាជាថ្មី
    Get.delete<EducationsScreenViewController>();
    Get.put(EducationsScreenViewController());
  }
}
