import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check
    final selectedCount = controller.selectedApplicantIds.length;

    String realStatus = 'pending';
    if (selectedCount > 0) {
      final firstSelectedId = controller.selectedApplicantIds.first;
      final applicant = controller.applicants.firstWhere(
        (app) => app.applicationId == firstSelectedId,
      );
      realStatus = applicant.status.toLowerCase();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic BG
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                              .tr // 🟢 Added .tr
                        : "Take Action (@count selected)".trParams({
                            'count': selectedCount.toString(),
                          }), // 🟢 Added .trParams
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isSchedulingInterview
                          ? AppColors.success
                          : (isDark
                                ? Colors.white
                                : Colors.black87), // 🟢 Dynamic Text
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isSchedulingInterview)
                _buildInterviewForm(isDark)
              else ...[
                if (realStatus == 'pending')
                  _buildActionButton(
                    "Move to Shortlisted".tr, // 🟢 Added .tr
                    LucideIcons.star,
                    Colors.blue,
                    'shortlisted',
                  ),

                if (realStatus == 'pending' || realStatus == 'shortlisted')
                  _buildActionButton(
                    "Schedule Interview".tr, // 🟢 Added .tr
                    LucideIcons.calendarClock,
                    AppColors.success,
                    'interview',
                  ),

                if (realStatus == 'interview')
                  _buildActionButton(
                    "Hire Candidates".tr, // 🟢 Added .tr
                    LucideIcons.briefcase,
                    Colors.teal,
                    'hired',
                  ),

                Divider(
                  height: 32,
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
                ),
                _buildActionButton(
                  "Reject Candidates".tr, // 🟢 Added .tr
                  LucideIcons.ban,
                  isDark ? Colors.redAccent : Colors.red, // 🟢 Dynamic Color
                  'rejected',
                  isOutlined: true,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    String status, {
    bool isOutlined = false,
    bool isDark = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: isOutlined
            ? OutlinedButton.icon(
                onPressed: () => _handleAction(status, isDark),
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
                onPressed: () => _handleAction(status, isDark),
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

  Widget _buildInterviewForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Interview Date & Time".tr, // 🟢 Added .tr
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
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
              color: isDark
                  ? AppColors.darkInputBackground
                  : Colors.white, // 🟢 Dynamic BG
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null || _selectedTime == null
                      ? "Select Date & Time"
                            .tr // 🟢 Added .tr
                      : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year} at ${_selectedTime!.format(context)}",
                  style: TextStyle(
                    color: _selectedDate == null
                        ? (isDark
                              ? AppColors.darkTextHint
                              : Colors.grey.shade600) // 🟢 Dynamic Null Hint
                        : (isDark
                              ? Colors.white
                              : Colors.black87), // 🟢 Dynamic Value
                    fontSize: 15,
                  ),
                ),
                Icon(
                  LucideIcons.calendar,
                  size: 18,
                  color: isDark
                      ? AppColors.darkIconSecondary
                      : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          "Location / Link".tr, // 🟢 Added .tr
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Text
          decoration: InputDecoration(
            hintText:
                "E.g., Floor 5, Jobber City HQ or Zoom Link".tr, // 🟢 Added .tr
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.white, // 🟢 Dynamic BG
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.success),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          "Message to Candidate (Optional)".tr, // 🟢 Added .tr
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _messageController,
          maxLines: 3,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ), // 🟢 Dynamic Text
          decoration: InputDecoration(
            hintText:
                "E.g., Please prepare a small presentation.".tr, // 🟢 Added .tr
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputBackground
                : Colors.white, // 🟢 Dynamic BG
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkCardBorder : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.success),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() => _isSchedulingInterview = false);
                },
                child: Text(
                  "Cancel".tr, // 🟢 Added .tr
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    Get.snackbar(
                      "Required".tr, // 🟢 Added .tr
                      "Please select both date and time".tr, // 🟢 Added .tr
                      backgroundColor: isDark
                          ? AppColors.error.withValues(alpha: 0.15)
                          : Colors.red.shade50,
                      colorText: isDark
                          ? Colors.redAccent
                          : Colors.red.shade700,
                    );
                    return;
                  }
                  if (_locationController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Required".tr, // 🟢 Added .tr
                      "Please provide a location or meeting link"
                          .tr, // 🟢 Added .tr
                      backgroundColor: isDark
                          ? AppColors.error.withValues(alpha: 0.15)
                          : Colors.red.shade50,
                      colorText: isDark
                          ? Colors.redAccent
                          : Colors.red.shade700,
                    );
                    return;
                  }

                  final scheduleDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );

                  Get.back();

                  controller.bulkUpdateStatus(
                    'interview',
                    interviewSchedule: {
                      'date': scheduleDateTime.toUtc().toIso8601String(),
                      'location': _locationController.text.trim(),
                    },
                    feedback: _messageController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Schedule".tr, // 🟢 Added .tr
                  style: const TextStyle(
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

  void _handleAction(String status, bool isDark) {
    if (status == 'interview') {
      setState(() => _isSchedulingInterview = true);
    } else {
      String actionName = status.tr;
      if (status == 'shortlisted') actionName = "Shortlist".tr; // 🟢 Added .tr
      if (status == 'hired') actionName = "Hire".tr; // 🟢 Added .tr
      if (status == 'rejected') actionName = "Reject".tr; // 🟢 Added .tr

      Get.dialog(
        AlertDialog(
          backgroundColor: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic Dialog BG
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
                    ? (isDark ? Colors.redAccent : Colors.red)
                    : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "Confirm Action".tr, // 🟢 Added .tr
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to @action @count candidate(s)? This action cannot be undone."
                .trParams({
                  'action': actionName.toLowerCase(),
                  'count': controller.selectedApplicantIds.length.toString(),
                }), // 🟢 Added .trParams
            style: TextStyle(
              fontSize: 15,
              color: isDark ? AppColors.darkTextSecondary : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel".tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                controller.bulkUpdateStatus(status);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'rejected'
                    ? (isDark ? Colors.redAccent : Colors.red)
                    : AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Confirm".tr, // 🟢 Added .tr
                style: const TextStyle(
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
