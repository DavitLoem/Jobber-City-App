part of 'interview_detail_view.dart';

class InterviewDetailViewController extends GetxController {
  final InterviewService _interviewService = InterviewService();

  final interview = Rxn<InterviewModel>();
  final isLoading = true.obs;
  final isUpdating = false.obs;
  final isJoining = false.obs;
  final errorMessage = ''.obs;
  final isEmployer = false.obs;

  DateTime? _rescheduleDate;
  TimeOfDay? _rescheduleTime;
  final reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final role = await TokenStorage.getUserRole();
    isEmployer.value = role == 'employer';

    final args = Get.arguments;
    String? id;
    if (args is InterviewModel) {
      interview.value = args;
      id = args.id;
    } else if (args is String) {
      id = args;
    }

    if (id == null) {
      errorMessage.value = 'Interview not found.'.tr; // 🟢 Added .tr
      isLoading.value = false;
      return;
    }

    await _fetch(id);
  }

  Future<void> _fetch(String id) async {
    isLoading.value = true;
    try {
      interview.value = await _interviewService.getInterview(id);
    } catch (e) {
      errorMessage.value = 'Could not load this interview.'.tr; // 🟢 Added .tr
      debugPrint('[InterviewDetail] fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinInterview() async {
    final current = interview.value;
    if (current == null || isJoining.value) return;
    isJoining.value = true;
    try {
      final result = await _interviewService.joinInterview(current.id);
      final roomNameStr = result.meetingUrl.split('/').last;

      var options = JitsiMeetConferenceOptions(
        room: roomNameStr,
        serverURL: "https://meet.jit.si",
        configOverrides: {
          "startWithAudioMuted": true,
          "startWithVideoMuted": true,
          "subject": "Jobber City Interview",
        },
      );

      final jitsiMeet = JitsiMeet();
      await jitsiMeet.join(
        options,
        JitsiMeetEventListener(
          conferenceJoined: (url) {
            debugPrint("Meeting joined: $url");
          },
          conferenceTerminated: (url, error) {
            debugPrint("Meeting closed. Updating status...");
            _fetch(current.id);
          },
        ),
      );
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Could not join interview'.tr, // 🟢 Added .tr
        message.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint('[InterviewDetail] join error: $e');
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> markCompleted() async {
    final current = interview.value;
    if (current == null || isUpdating.value) return;
    isUpdating.value = true;
    try {
      interview.value = await _interviewService.completeInterview(current.id);
      final isDark = Get.isDarkMode; // 🟢 Theme Check
      Get.snackbar(
        'Interview completed'.tr, // 🟢 Added .tr
        'Marked as completed.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green.shade50,
        colorText: isDark ? Colors.greenAccent : Colors.green.shade700,
      );
    } catch (e) {
      final isDark = Get.isDarkMode;
      Get.snackbar(
        'Could not update'.tr, // 🟢 Added .tr
        e.toString().replaceAll('Exception: ', '').tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint('[InterviewDetail] complete error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  void showRescheduleSheet(BuildContext context) {
    final current = interview.value;
    if (current == null) return;
    _rescheduleDate = current.scheduledAt;
    _rescheduleTime = TimeOfDay.fromDateTime(current.scheduledAt);

    final isDark = Get.isDarkMode; // 🟢 Theme Check

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground
                : Colors.white, // 🟢 Dynamic BG
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reschedule Interview'.tr, // 🟢 Added .tr
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : AppColors.textPrimary, // 🟢 Dynamic Title
                ),
              ),
              const SizedBox(height: 20),
              _pickerRow(
                icon: Icons.event_rounded,
                label: _rescheduleDate != null
                    ? _formatFullDate(_rescheduleDate!)
                    : 'Select date'.tr, // 🟢 Added .tr
                isDark: isDark,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        _rescheduleDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setSheetState(() => _rescheduleDate = picked);
                  }
                },
              ),
              const SizedBox(height: 12),
              _pickerRow(
                icon: Icons.schedule_rounded,
                label: _rescheduleTime != null
                    ? _rescheduleTime!.format(context)
                    : 'Select time'.tr, // 🟢 Added .tr
                isDark: isDark,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _rescheduleTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setSheetState(() => _rescheduleTime = picked);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _submitReschedule(current.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Confirm New Time'.tr, // 🟢 Added .tr
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _pickerRow({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          ), // 🟢 Dynamic Border
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white
                    : AppColors.textPrimary, // 🟢 Dynamic Text
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.darkIconSecondary
                  : AppColors.textTertiary, // 🟢 Dynamic Icon
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReschedule(String interviewId) async {
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    if (_rescheduleDate == null || _rescheduleTime == null) {
      Get.snackbar(
        'Required'.tr, // 🟢 Added .tr
        'Please pick both a date and a time.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        colorText: isDark ? Colors.orangeAccent : Colors.orange.shade800,
      );
      return;
    }
    final combined = DateTime(
      _rescheduleDate!.year,
      _rescheduleDate!.month,
      _rescheduleDate!.day,
      _rescheduleTime!.hour,
      _rescheduleTime!.minute,
    ).toUtc();

    if (!combined.isAfter(DateTime.now().toUtc())) {
      Get.snackbar(
        'Invalid time'.tr, // 🟢 Added .tr
        'Please choose a time in the future.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? Colors.orangeAccent.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        colorText: isDark ? Colors.orangeAccent : Colors.orange.shade800,
      );
      return;
    }

    Get.back(); // close sheet
    isUpdating.value = true;
    try {
      interview.value = await _interviewService.rescheduleInterview(
        interviewId,
        scheduledAt: combined,
      );
      Get.snackbar(
        'Interview rescheduled'.tr, // 🟢 Added .tr
        'The candidate has been notified.'.tr, // 🟢 Added .tr
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green.shade50,
        colorText: isDark ? Colors.greenAccent : Colors.green.shade700,
      );
    } catch (e) {
      Get.snackbar(
        'Could not reschedule'.tr, // 🟢 Added .tr
        e.toString().replaceAll('Exception: ', '').tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint('[InterviewDetail] reschedule error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  void showCancelSheet(BuildContext context) {
    reasonController.clear();
    final current = interview.value;
    if (current == null) return;
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic BG
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cancel Interview'.tr, // 🟢 Added .tr
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure? This cannot be undone.'.tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textTertiary, // 🟢 Dynamic Text
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ), // 🟢 Dynamic Input Text
              decoration: InputDecoration(
                hintText: 'Reason (optional)'.tr, // 🟢 Added .tr
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : AppColors.lightSurfaceVariant, // 🟢 Dynamic Input BG
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Keep Interview'.tr, // 🟢 Added .tr
                      style: TextStyle(
                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                      ), // 🟢 Dynamic Text
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      _submitCancel(current.id);
                    },
                    child: Text(
                      'Yes, Cancel'.tr, // 🟢 Added .tr
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _submitCancel(String interviewId) async {
    isUpdating.value = true;
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    try {
      interview.value = await _interviewService.cancelInterview(
        interviewId,
        reason: reasonController.text,
      );
      Get.snackbar(
        'Interview cancelled'.tr, // 🟢 Added .tr
        '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : Colors.green.shade50,
        colorText: isDark ? Colors.greenAccent : Colors.green.shade700,
      );
    } catch (e) {
      Get.snackbar(
        'Could not cancel'.tr, // 🟢 Added .tr
        e.toString().replaceAll('Exception: ', '').tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : Colors.red.shade50,
        colorText: isDark ? Colors.redAccent : Colors.red.shade700,
      );
      debugPrint('[InterviewDetail] cancel error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
