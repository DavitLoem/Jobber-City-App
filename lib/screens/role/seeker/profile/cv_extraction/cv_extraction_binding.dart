part of 'cv_extraction_view.dart';

class CvExtractionViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => CvExtractionViewController());
   }
}