import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jobber_city/core/api/services/interview/interview_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/interview/interview_models.dart';

part 'interview_detail_controller.dart';

/// Full detail view for one interview — shared by both seeker and employer,
/// with role-aware actions (only the employer who scheduled it can
/// reschedule; either side can join/cancel/mark complete).
class InterviewDetailView extends GetView<InterviewDetailViewController> {
  const InterviewDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Interview Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.interview.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final interview = controller.interview.value;
        if (interview == null) {
          return Center(
            child: Text(
              controller.errorMessage.value.isNotEmpty ? controller.errorMessage.value : 'Interview not found.',
              style: const TextStyle(color: AppColors.textTertiary),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OtherPartyCard(interview: interview),
              const SizedBox(height: 16),
              _InfoCard(interview: interview),
              if (interview.notes != null && interview.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _NotesCard(notes: interview.notes!),
              ],
              if (interview.status == 'cancelled' && interview.cancelReason != null && interview.cancelReason!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _CancelReasonCard(reason: interview.cancelReason!),
              ],
              const SizedBox(height: 24),
              _ActionButtons(),
            ],
          ),
        );
      }),
    );
  }
}

class _OtherPartyCard extends StatelessWidget {
  final InterviewModel interview;
  const _OtherPartyCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    final other = interview.otherParty;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
            clipBehavior: Clip.hardEdge,
            child: other.avatarUrl != null && other.avatarUrl!.isNotEmpty
                ? Image.network(other.avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(other.name))
                : _fallback(other.name),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  other.name,
                  style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  other.role == 'employer' ? 'Employer' : 'Candidate',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textTertiary),
                ),
                if (interview.jobTitle != null && interview.jobTitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    interview.jobTitle!,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
          _StatusPill(status: interview.status),
        ],
      ),
    );
  }

  Widget _fallback(String name) => Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary),
        ),
      );
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'scheduled' => ('Scheduled', AppColors.primary),
      'ongoing' => ('Live Now', AppColors.success),
      'completed' => ('Completed', AppColors.textTertiary),
      'cancelled' => ('Cancelled', AppColors.error),
      'no_show' => ('No-show', AppColors.error),
      _ => (status, AppColors.textTertiary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final InterviewModel interview;
  const _InfoCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          _row(Icons.event_rounded, 'Date', _formatFullDate(interview.scheduledAt)),
          const SizedBox(height: 14),
          _row(Icons.schedule_rounded, 'Time', _formatTime(interview.scheduledAt)),
          const SizedBox(height: 14),
          _row(Icons.timer_outlined, 'Duration', '${interview.durationMinutes} minutes'),
          const SizedBox(height: 14),
          _row(Icons.videocam_outlined, 'Platform', 'Video call (Jitsi Meet)'),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String notes;
  const _NotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notes', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(notes, style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}

class _CancelReasonCard extends StatelessWidget {
  final String reason;
  const _CancelReasonCard({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cancellation reason: $reason',
              style: const TextStyle(fontSize: 12.5, color: AppColors.error, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends GetView<InterviewDetailViewController> {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final interview = controller.interview.value;
      if (interview == null) return const SizedBox.shrink();

      final children = <Widget>[];

      if (interview.isJoinable) {
        children.add(
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: controller.isJoining.value ? null : controller.joinInterview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: controller.isJoining.value
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.videocam_rounded, color: Colors.white),
              label: Text(
                interview.status == 'ongoing' ? 'Rejoin Interview' : 'Join Interview',
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        );
      }

      if (interview.status == 'ongoing') {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: controller.isUpdating.value ? null : controller.markCompleted,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Mark as Completed', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }

      if (interview.status == 'scheduled' && controller.isEmployer.value) {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: controller.isUpdating.value ? null : () => controller.showRescheduleSheet(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.edit_calendar_outlined, size: 18),
              label: const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }

      if (interview.isCancellable) {
        children.add(const SizedBox(height: 10));
        children.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: controller.isUpdating.value ? null : () => controller.showCancelSheet(context),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Cancel Interview', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }

      return Column(children: children);
    });
  }
}

String _formatFullDate(DateTime dt) {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _formatTime(DateTime dt) {
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}
