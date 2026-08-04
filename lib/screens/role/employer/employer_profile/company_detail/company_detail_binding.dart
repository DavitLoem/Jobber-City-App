part of 'company_detail_view.dart';

class CompanyDetailViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CompanyDetailViewController());
   }
}