part of 'cv_generator_view.dart';

class CvGeneratorViewController extends GetxController {
  final CvGeneratorService _cvService = CvGeneratorService();

  final isLoading = true.obs;
  final isGenerating = false.obs;
  final templates = <CvTemplateModel>[].obs;
  final currentCv = Rxn<CurrentCvModel>();
  final selectedTemplateId = ''.obs;
  final profileWarning = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _cvService.listTemplates(),
        _cvService.getCurrentCv(),
      ]);
      templates.assignAll(results[0] as List<CvTemplateModel>);
      currentCv.value = results[1] as CurrentCvModel;

      // Default the picker to whichever template they already used, so
      // "Regenerate" doesn't silently switch templates on them; otherwise
      // just default to the first one available.
      final existingTemplateId = currentCv.value?.templateId;
      if (existingTemplateId != null && templates.any((t) => t.id == existingTemplateId)) {
        selectedTemplateId.value = existingTemplateId;
      } else if (templates.isNotEmpty) {
        selectedTemplateId.value = templates.first.id;
      }
    } catch (e) {
      debugPrint('[CvGenerator] load error: $e');
      Get.snackbar(
        'Could not load CV templates',
        'Please check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateCv() async {
    if (selectedTemplateId.value.isEmpty || isGenerating.value) return;
    isGenerating.value = true;
    profileWarning.value = '';

    try {
      final result = await _cvService.generateCv(selectedTemplateId.value);
      currentCv.value = CurrentCvModel(
        cvUrl: result.cvUrl,
        templateId: result.templateId,
        generatedAt: result.generatedAt,
      );

      Get.snackbar(
        'CV Generated 🎉',
        'Your CV is ready to view and share.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryLight,
        colorText: AppColors.primary,
        duration: const Duration(seconds: 3),
      );

      viewCurrentCv();
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      if (message.toLowerCase().contains('complete your profile')) {
        // Backend refused because the profile is too empty to build a CV
        // from — surface this as a persistent, actionable notice instead
        // of a snackbar that disappears before they can act on it.
        profileWarning.value = message;
      } else {
        Get.snackbar(
          'Could not generate CV',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade700,
        );
      }
      debugPrint('[CvGenerator] generate error: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  void viewCurrentCv() {
    final url = currentCv.value?.cvUrl;
    if (url == null || url.isEmpty) return;
    Get.to(() => CvPdfView(pdfUrl: url));
  }
}
