import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jobber_city/core/api/services/interview/interview_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/interview/interview_models.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'schedule_interview_binding.dart';
part 'schedule_interview_controller.dart';

/// Employer-only screen for scheduling a video interview with a seeker.
/// Reached from `CandidateDetailView`'s "Schedule Video Interview" action,
/// with the seeker's identity pre-filled via [ScheduleInterviewArgs].
class ScheduleInterviewView extends GetView<ScheduleInterviewViewController> {
  const ScheduleInterviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text('Schedule Interview', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CandidateCard(args: controller.args),
            const SizedBox(height: 28),

            const Text('Interview Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Obx(() => _PickerField(
                  icon: Icons.event_rounded,
                  value: controller.selectedDate.value != null ? _formatDate(controller.selectedDate.value!) : 'Select a date',
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value ?? DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) controller.selectedDate.value = picked;
                  },
                )),

            const SizedBox(height: 16),
            const Text('Interview Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Obx(() => _PickerField(
                  icon: Icons.schedule_rounded,
                  value: controller.selectedTime.value != null ? controller.selectedTime.value!.format(context) : 'Select a time',
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: controller.selectedTime.value ?? TimeOfDay.now());
                    if (picked != null) controller.selectedTime.value = picked;
                  },
                )),

            const SizedBox(height: 16),
            const Text('Duration', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 10,
                  children: [15, 30, 45, 60].map((mins) {
                    final isSelected = controller.durationMinutes.value == mins;
                    return ChoiceChip(
                      label: Text('$mins min'),
                      selected: isSelected,
                      onSelected: (_) => controller.durationMinutes.value = mins,
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.grey.shade50,
                      side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 16),
            const Text('Notes (Optional)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'E.g., Please prepare a short portfolio walkthrough.',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.videocam_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'A private video call link will be generated automatically — no extra app needed on either side.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value ? null : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                        : const Text('Schedule Interview', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final ScheduleInterviewArgs args;
  const _CandidateCard({required this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: args.seekerAvatarUrl != null && args.seekerAvatarUrl!.isNotEmpty
                ? NetworkImage(args.seekerAvatarUrl!)
                : null,
            child: args.seekerAvatarUrl == null || args.seekerAvatarUrl!.isEmpty
                ? Text(
                    args.seekerName.isNotEmpty ? args.seekerName[0].toUpperCase() : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(args.seekerName, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.black87)),
                if (args.jobTitle != null && args.jobTitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('For: ${args.jobTitle}', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;
  const _PickerField({required this.icon, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}
