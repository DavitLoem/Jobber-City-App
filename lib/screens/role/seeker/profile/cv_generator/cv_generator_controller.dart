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

      final existingTemplateId = currentCv.value?.templateId;
      if (existingTemplateId != null &&
          templates.any((t) => t.id == existingTemplateId)) {
        selectedTemplateId.value = existingTemplateId;
      } else if (templates.isNotEmpty) {
        selectedTemplateId.value = templates.first.id;
      }
    } catch (e) {
      debugPrint('[CvGenerator] load error: $e');
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Could not load CV templates'.tr, // 🟢 Added .tr
        'Please check your connection and try again.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.redAccent
            : Colors.red.shade700, // 🟢 Dynamic Text
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateCv() async {
    if (selectedTemplateId.value.isEmpty || isGenerating.value) return;
    isGenerating.value = true;
    profileWarning.value = '';

    final isDark = Get.isDarkMode; // 🟢 Theme Check

    try {
      final result = await _cvService.generateCv(selectedTemplateId.value);
      currentCv.value = CurrentCvModel(
        cvUrl: result.cvUrl,
        templateId: result.templateId,
        generatedAt: result.generatedAt,
      );

      Get.snackbar(
        'CV Generated 🎉'.tr, // 🟢 Added .tr
        'Your CV is ready to view and share.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.primaryLight, // 🟢 Dynamic BG
        colorText: isDark
            ? Colors.blueAccent
            : AppColors.primary, // 🟢 Dynamic Text
        duration: const Duration(seconds: 3),
      );

      viewCurrentCv();
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      if (message.toLowerCase().contains('complete your profile')) {
        profileWarning.value =
            message.tr; // 🟢 Pass translation if mapped from backend
      } else {
        Get.snackbar(
          'Could not generate CV'.tr, // 🟢 Added .tr
          message.tr, // 🟢 Translate exception message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isDark
              ? AppColors.error.withValues(alpha: 0.15)
              : Colors.red.shade50, // 🟢 Dynamic BG
          colorText: isDark
              ? Colors.redAccent
              : Colors.red.shade700, // 🟢 Dynamic Text
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
