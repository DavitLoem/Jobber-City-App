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
      interview.value = args; // show cached data immediately, then refresh
      id = args.id;
    } else if (args is String) {
      id = args;
    }

    if (id == null) {
      errorMessage.value = 'Interview not found.';
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
      errorMessage.value = 'Could not load this interview.';
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
      // ហៅ API ដើម្បីប្រាប់ Backend ថាយើងចូលរួម និងប្តូរ Status ទៅ ongoing
      final result = await _interviewService.joinInterview(current.id);

      // 🎯 ១. បំបែកយកតែ "ឈ្មោះបន្ទប់" ចេញពី URL (ព្រោះ SDK ថ្មីទាមទារតែឈ្មោះបន្ទប់ទេ)
      // ឧទាហរណ៍៖ បើ URL គឺ https://meet.jit.si/jobbercity-xxx វានឹងយកតែ jobbercity-xxx
      final roomNameStr = result.meetingUrl.split('/').last;

      // 🎯 ២. កំណត់ Option ដោយប្រើ JitsiMeetConferenceOptions ថ្មី
      var options = JitsiMeetConferenceOptions(
        room: roomNameStr,
        serverURL: "https://meet.jit.si",
        // SDK ថ្មីប្រើ configOverrides សម្រាប់កំណត់កាមេរ៉ា និងម៉ៃក្រូហ្វូន
        configOverrides: {
          "startWithAudioMuted": true,
          "startWithVideoMuted": true,
          "subject": "Jobber City Interview",
        },
      );

      // 🎯 ៣. ហៅ SDK ឱ្យបើកបន្ទប់
      final jitsiMeet = JitsiMeet();
      await jitsiMeet.join(
        options,
        JitsiMeetEventListener(
          conferenceJoined: (url) {
            debugPrint("Meeting joined: $url");
          },
          conferenceTerminated: (url, error) {
            debugPrint("Meeting closed. Updating status...");
            // ពេលគាត់ចុចបិទការហៅ ទាញយកទិន្នន័យម្តងទៀតដើម្បី Update Status
            _fetch(current.id);
          },
        ),
      );
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Could not join interview',
        message,
        snackPosition: SnackPosition.TOP,
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
      Get.snackbar(
        'Interview completed',
        'Marked as completed.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Could not update',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
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

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reschedule Interview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _pickerRow(
                icon: Icons.event_rounded,
                label: _rescheduleDate != null
                    ? _formatFullDate(_rescheduleDate!)
                    : 'Select date',
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        _rescheduleDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null)
                    setSheetState(() => _rescheduleDate = picked);
                },
              ),
              const SizedBox(height: 12),
              _pickerRow(
                icon: Icons.schedule_rounded,
                label: _rescheduleTime != null
                    ? _rescheduleTime!.format(context)
                    : 'Select time',
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _rescheduleTime ?? TimeOfDay.now(),
                  );
                  if (picked != null)
                    setSheetState(() => _rescheduleTime = picked);
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
                  child: const Text(
                    'Confirm New Time',
                    style: TextStyle(
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReschedule(String interviewId) async {
    if (_rescheduleDate == null || _rescheduleTime == null) {
      Get.snackbar(
        'Required',
        'Please pick both a date and a time.',
        snackPosition: SnackPosition.TOP,
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
      // ប្រៀបធៀបជាមួយ UTC ដូចគ្នា
      Get.snackbar(
        'Invalid time',
        'Please choose a time in the future.',
        snackPosition: SnackPosition.TOP,
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
        'Interview rescheduled',
        'The candidate has been notified.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Could not reschedule',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
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

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cancel Interview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure? This cannot be undone.',
              style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                filled: true,
                fillColor: AppColors.lightSurfaceVariant,
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
                    child: const Text('Keep Interview'),
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
                    child: const Text(
                      'Yes, Cancel',
                      style: TextStyle(
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
    try {
      interview.value = await _interviewService.cancelInterview(
        interviewId,
        reason: reasonController.text,
      );
      Get.snackbar('Interview cancelled', '', snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar(
        'Could not cancel',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
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
