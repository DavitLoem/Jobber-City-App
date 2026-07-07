part of 'job_detail_view.dart';

class JobDetailViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => JobDetailViewController());
   }
}