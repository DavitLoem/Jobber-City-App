part of 'job_list_view.dart';

class JobListViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => JobListViewController());
   }
}