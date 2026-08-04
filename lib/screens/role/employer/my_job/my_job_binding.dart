part of 'my_job_view.dart';

class MyJobViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => MyJobViewController());
   }
}