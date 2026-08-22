import 'package:get/get.dart';
import 'package:jobber_city/screens/shared/chat/seeker_directory/seeker_directory_view.dart';

class SeekerDirectoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SeekerDirectoryController(), fenix: false);
  }
}
