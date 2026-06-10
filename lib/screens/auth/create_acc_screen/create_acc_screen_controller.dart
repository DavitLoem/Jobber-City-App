part of 'create_acc_screen_view.dart';

class CreateAccScreenViewController extends GetxController {
  var selectedIndex = 0.obs;
  
  var agreeToTermsEmployer = false.obs; 
  var agreeToTermsSeeker = false.obs; 
  var rememberMe = false.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void toggleTermsEmployer() {
    agreeToTermsEmployer.value = !agreeToTermsEmployer.value;
  }
  
  void toggleTermsSeeker() {
    agreeToTermsSeeker.value = !agreeToTermsSeeker.value;
  }
}