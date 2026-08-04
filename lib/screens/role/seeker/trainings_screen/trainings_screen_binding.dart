part of 'trainings_screen_view.dart';

class TrainingsScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.delete<TrainingsScreenViewController>();
    Get.put(TrainingsScreenViewController());
  }
}
