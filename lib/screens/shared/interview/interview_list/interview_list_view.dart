import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jobber_city/core/api/services/interview/interview_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/interview/interview_models.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'interview_list_controller.dart';

/// Video-interview inbox shared by both seeker and employer accounts — same
/// screen for both, the backend only ever returns interviews the current
/// user participates in (see `interview_service.py` participant scoping).
class InterviewListView extends GetView<InterviewListViewController> {
  const InterviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Interviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          _FilterTabs(
            selected: controller.filter.value,
            onChanged: controller.setFilter,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (controller.errorMessage.value.isNotEmpty && controller.interviews.isEmpty) {
                return _ErrorState(message: controller.errorMessage.value, onRetry: controller.fetchInterviews);
              }

              final visible = controller.visibleInterviews;
              if (visible.isEmpty) {
                return _EmptyState(isUpcomingTab: controller.filter.value == _InterviewFilter.upcoming);
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetchInterviews,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 82, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final interview = visible[index];
                    return _InterviewTile(
                      interview: interview,
                      onTap: () => controller.openInterview(interview),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

enum _InterviewFilter { upcoming, past }

class _FilterTabs extends StatelessWidget {
  final _InterviewFilter selected;
  final ValueChanged<_InterviewFilter> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.lightSurfaceVariant, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: _tab('Upcoming', _InterviewFilter.upcoming)),
            Expanded(child: _tab('Past', _InterviewFilter.past)),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, _InterviewFilter value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _InterviewTile extends StatelessWidget {
  final InterviewModel interview;
  final VoidCallback onTap;
  const _InterviewTile({required this.interview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final other = interview.otherParty;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(name: other.name, avatarUrl: other.avatarUrl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          other.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(status: interview.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (interview.jobTitle != null && interview.jobTitle!.isNotEmpty) ...[
                    Text(
                      interview.jobTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.event_rounded, size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(interview.scheduledAt),
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textTertiary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.timer_outlined, size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${interview.durationMinutes} min',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'scheduled' => ('Scheduled', AppColors.primary),
      'ongoing' => ('Live', AppColors.success),
      'completed' => ('Completed', AppColors.textTertiary),
      'cancelled' => ('Cancelled', AppColors.error),
      'no_show' => ('No-show', AppColors.error),
      _ => (status, AppColors.textTertiary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  const _Avatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
      clipBehavior: Clip.hardEdge,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? Image.network(avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback())
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isUpcomingTab;
  const _EmptyState({required this.isUpcomingTab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.videocam_outlined, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              isUpcomingTab ? 'No upcoming interviews' : 'No past interviews',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcomingTab
                  ? 'Scheduled video interviews will show up here.'
                  : 'Completed and cancelled interviews will show up here.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: AppColors.textTertiary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.textTertiary, size: 40),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textTertiary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '${months[dt.month - 1]} ${dt.day}, $hour:$minute $period';
}
