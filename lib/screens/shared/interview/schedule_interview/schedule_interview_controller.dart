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
      args = ScheduleInterviewArgs(seekerUserId: '', seekerName: 'Candidate');
    }
  }

  Future<void> submit() async {
    if (args.seekerUserId.isEmpty) {
      Get.snackbar('Error', 'Missing candidate information.', snackPosition: SnackPosition.TOP);
      return;
    }
    if (selectedDate.value == null || selectedTime.value == null) {
      Get.snackbar('Required', 'Please select both a date and a time.', snackPosition: SnackPosition.TOP);
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
      Get.snackbar('Invalid time', 'Please choose a date and time in the future.', snackPosition: SnackPosition.TOP);
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
        'Interview Scheduled 🎉',
        '${args.seekerName} has been notified.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.successBackground,
        colorText: AppColors.success,
        duration: const Duration(seconds: 3),
      );
      Get.toNamed(AppRoutes.interviewDetail, arguments: interview);
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      Get.snackbar('Could not schedule interview', message, snackPosition: SnackPosition.TOP);
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
