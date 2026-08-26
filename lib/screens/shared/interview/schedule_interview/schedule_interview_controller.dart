part of 'schedule_interview_view.dart';

class ScheduleInterviewViewController extends GetxController {
  final InterviewService _interviewService = InterviewService();

  late ScheduleInterviewArgs args;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final durationMinutes = 30.obs;
  final notesController = TextEditingController();
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ScheduleInterviewArgs) {
      args = Get.arguments as ScheduleInterviewArgs;

      // 🎯 បន្ថែម Logic Pre-fill នៅទីនេះ
      if (args.existingDate != null) {
        selectedDate.value = args.existingDate;
        selectedTime.value = TimeOfDay.fromDateTime(args.existingDate!);
      }
    } else {
      args = ScheduleInterviewArgs(
        seekerUserId: '',
        seekerName: 'Candidate'.tr,
      ); // 🟢 Added .tr
    }
  }

  Future<void> submit() async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    if (args.seekerUserId.isEmpty) {
      Get.snackbar(
        'Error'.tr, // 🟢 Added .tr
        'Missing candidate information.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      return;
    }
    if (selectedDate.value == null || selectedTime.value == null) {
      Get.snackbar(
        'Required'.tr, // 🟢 Added .tr
        'Please select both a date and a time.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        colorText: isDark ? Colors.orangeAccent : Colors.orange.shade800,
      );
      return;
    }

    final scheduledAt = DateTime(
      selectedDate.value!.year,
      selectedDate.value!.month,
      selectedDate.value!.day,
      selectedTime.value!.hour,
      selectedTime.value!.minute,
    );

    if (!scheduledAt.isAfter(DateTime.now())) {
      Get.snackbar(
        'Invalid time'.tr, // 🟢 Added .tr
        'Please choose a date and time in the future.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        colorText: isDark ? Colors.orangeAccent : Colors.orange.shade800,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final interview = await _interviewService.scheduleInterview(
        seekerUserId: args.seekerUserId,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes.value,
        applicationId: args.applicationId,
        notes: notesController.text,
      );

      Get.back();
      Get.snackbar(
        'Interview Scheduled 🎉'.tr, // 🟢 Added .tr
        '@name has been notified.'.trParams({
          'name': args.seekerName,
        }), // 🟢 Added .trParams
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.successBackground,
        colorText: isDark ? Colors.greenAccent : AppColors.success,
        duration: const Duration(seconds: 3),
      );
      Get.toNamed(AppRoutes.interviewDetail, arguments: interview);
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Could not schedule interview'.tr, // 🟢 Added .tr
        message.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint('[ScheduleInterview] submit error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
