part of 'language_view.dart';

class LanguageViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => LanguageViewController());
   }
}