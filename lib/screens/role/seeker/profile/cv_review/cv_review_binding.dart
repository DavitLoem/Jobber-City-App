part of 'cv_review_view.dart';

class CvReviewViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CvReviewViewController());
   }
}