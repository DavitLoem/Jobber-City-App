part of 'training_view.dart';

class TrainingViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => TrainingViewController());
   }
}