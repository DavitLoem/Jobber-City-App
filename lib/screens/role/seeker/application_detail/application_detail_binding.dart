part of 'application_detail_view.dart';

class ApplicationDetailViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => ApplicationDetailViewController());
   }
}