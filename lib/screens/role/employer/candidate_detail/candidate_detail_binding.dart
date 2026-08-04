part of 'candidate_detail_view.dart';

class CandidateDetailViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CandidateDetailViewController());
   }
}