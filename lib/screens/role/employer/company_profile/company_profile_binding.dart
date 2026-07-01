part of 'company_profile_view.dart';

class CompanyProfileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyProfileViewController());
  }
}