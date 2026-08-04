part of 'candidates_view.dart';

class CandidatesViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CandidatesViewController());
   }
}