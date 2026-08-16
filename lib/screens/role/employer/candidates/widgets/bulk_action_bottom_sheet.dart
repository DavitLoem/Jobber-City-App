import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../candidates_view.dart';

class BulkActionBottomSheet extends StatefulWidget {
  const BulkActionBottomSheet({super.key});

  @override
  State<BulkActionBottomSheet> createState() => _BulkActionBottomSheetState();
}

class _BulkActionBottomSheetState extends State<BulkActionBottomSheet> {
  final CandidatesViewController controller =
      Get.find<CandidatesViewController>();

  bool _isSchedulingInterview = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // 🟢 ១. បន្ថែម Controller សម្រាប់ចាប់យកអក្សរពី Textfield
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = controller.selectedApplicantIds.length;

    // 🎯 ១. ទាញយក Status ពិតប្រាកដរបស់បេក្ខជនដែលបាន Select (ជំនួសការប្រើ Tab Index)
    String realStatus = 'pending';
    if (selectedCount > 0) {
      final firstSelectedId = controller.selectedApplicantIds.first;
      final applicant = controller.applicants.firstWhere(
        (app) => app.applicationId == firstSelectedId,
      );
      realStatus = applicant.status.toLowerCase();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isSchedulingInterview
                        ? "Schedule Interview"
                        : "Take Action ($selectedCount selected)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isSchedulingInterview
                          ? const Color(0xFF10B981)
                          : Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isSchedulingInterview)
                _buildInterviewForm()
              else ...[
                // 🎯 ២. បង្ហាញប៊ូតុងដោយផ្អែកលើ Status ពិតប្រាកដ (លែងរញ៉េរញ៉ៃដូចក្នុង Tab All ទៀតហើយ)
                if (realStatus == 'pending')
                  _buildActionButton(
                    "Move to Shortlisted",
                    LucideIcons.star,
                    Colors.blue,
                    'shortlisted',
                  ),

                if (realStatus == 'pending' || realStatus == 'shortlisted')
                  _buildActionButton(
                    "Schedule Interview",
                    LucideIcons.calendarClock,
                    Colors.green,
                    'interview',
                  ),

                if (realStatus == 'interview')
                  _buildActionButton(
                    "Hire Candidates",
                    LucideIcons.briefcase,
                    Colors.teal,
                    'hired',
                  ),

                const Divider(height: 32),
                _buildActionButton(
                  "Reject Candidates",
                  LucideIcons.ban,
                  Colors.red,
                  'rejected',
                  isOutlined: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── អនុគមន៍គូរប៊ូតុង Generic ──
  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    String status, {
    bool isOutlined = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: isOutlined
            ? OutlinedButton.icon(
                onPressed: () => _handleAction(status),
                icon: Icon(icon, color: color),
                label: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : ElevatedButton.icon(
                onPressed: () => _handleAction(status),
                icon: Icon(icon, color: Colors.white),
                label: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ),
    );
  }

  // ── 🟢 អនុគមន៍គូរ Form សម្ភាសន៍ថ្មី (ដូចក្នុងរូប) ──
  Widget _buildInterviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Date & Time
        const Text(
          "Interview Date & Time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final time = await showTimePicker(
                // ignore: use_build_context_synchronously
                context: context,
                initialTime: const TimeOfDay(hour: 9, minute: 0),
              );
              if (time != null) {
                setState(() {
                  _selectedDate = date;
                  _selectedTime = time;
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null || _selectedTime == null
                      ? "Select Date & Time"
                      : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year} at ${_selectedTime!.format(context)}",
                  style: TextStyle(
                    color: _selectedDate == null
                        ? Colors.grey.shade600
                        : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  LucideIcons.calendar,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Location / Link
        const Text(
          "Location / Link",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: "E.g., Floor 5, Jobber City HQ or Zoom Link",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Message to Candidate
        const Text(
          "Message to Candidate (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "E.g., Please prepare a small presentation.",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 4. Action Buttons (Cancel & Schedule)
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() => _isSchedulingInterview = false);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2, // ឱ្យប៊ូតុង Schedule វែងជាង Cancel បន្តិច
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    Get.snackbar(
                      "Required",
                      "Please select both date and time",
                      backgroundColor: Colors.red.shade50,
                      colorText: Colors.red.shade700,
                    );
                    return;
                  }
                  if (_locationController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Required",
                      "Please provide a location or meeting link",
                      backgroundColor: Colors.red.shade50,
                      colorText: Colors.red.shade700,
                    );
                    return;
                  }

                  // បញ្ចូលគ្នារវាង Date និង Time ទៅជា ISO String
                  final scheduleDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );

                  Get.back(); // បិទ Bottom Sheet

                  // 🟢 បោះទិន្នន័យទាំងអស់ទៅកាន់ Controller
                  controller.bulkUpdateStatus(
                    'interview',
                    interviewSchedule: {
                      'date': scheduleDateTime.toUtc().toIso8601String(),
                      'location': _locationController.text.trim(),
                    },
                    feedback: _messageController.text
                        .trim(), // ដាក់ Message ទៅក្នុង feedback
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAction(String status) {
    if (status == 'interview') {
      setState(() => _isSchedulingInterview = true);
    } else {
      // កំណត់ឈ្មោះ Action ឱ្យស្អាតសម្រាប់បង្ហាញក្នុង Dialog
      String actionName = status;
      if (status == 'shortlisted') actionName = "Shortlist";
      if (status == 'hired') actionName = "Hire";
      if (status == 'rejected') actionName = "Reject";

      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                status == 'rejected'
                    ? Icons.warning_rounded
                    : Icons.info_outline_rounded,
                color: status == 'rejected'
                    ? Colors.red
                    : const Color(0xFF4f7df7),
              ),
              const SizedBox(width: 8),
              const Text(
                "Confirm Action",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to $actionName ${controller.selectedApplicantIds.length} candidate(s)? This action cannot be undone.",
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // បិទ Modal
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(); // បិទ Modal
                Get.back(); // បិទ Bottom Sheet
                controller.bulkUpdateStatus(status); // បាញ់ API
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'rejected'
                    ? Colors.red
                    : const Color(0xFF4f7df7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}
