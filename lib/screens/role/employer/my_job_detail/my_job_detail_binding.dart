part of 'my_job_detail_view.dart';

class MyJobDetailViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => MyJobDetailViewController());
   }
}