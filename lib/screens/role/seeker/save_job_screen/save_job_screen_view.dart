import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

part 'save_job_screen_binding.dart';
part 'save_job_screen_controller.dart';

class SaveJobScreenView extends GetView<SaveJobScreenViewController> {
  const SaveJobScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => _buildFilterChips()),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      200, // Ensure minimum height
                ),
                child: Obx(() {
                  final jobs = controller.filteredJobs;
                  if (jobs.isEmpty) return _buildEmptyState();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildSavedJobCard(jobs[index], index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header: back button + title + saved count + clear-all ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Saved Jobs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    '${controller.savedJobs.length} job${controller.savedJobs.length == 1 ? '' : 's'} saved',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: controller.savedJobs.isEmpty ? 0 : 1,
              child: IgnorePointer(
                ignoring: controller.savedJobs.isEmpty,
                child: GestureDetector(
                  onTap: () => _confirmClearAll(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 19,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Clear all saved jobs?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will remove every job from your saved list. You can\'t undo this.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter chips (All / Remote / Onsite / Hybrid — derived from data) ──
  Widget _buildFilterChips() {
    final options = controller.filterOptions;
    if (controller.savedJobs.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = controller.selectedFilterIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectedFilterIndex.value = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.cardBorder,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                options[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Saved job card ──
  Widget _buildSavedJobCard(_SavedJobData job, int index) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(job.id),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60).clamp(0, 300)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.snackbar(
            job.title,
            'Job details aren\'t wired up yet — this screen is UI only.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primaryLight,
            colorText: AppColors.primary,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogoFallback(job.companyName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          job.companyName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildBookmarkButton(
                    onTap: () => controller.removeJob(job.id),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag(job.employmentType),
                  _buildTag(job.workType),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${job.minSalary} - \$${job.maxSalary}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${_periodShort(job.salaryPeriod)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Saved ${job.savedDaysAgo}d ago',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ──
  Widget _buildEmptyState() {
    final hasAnySaved = controller.savedJobs.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasAnySaved ? 'No jobs match this filter' : 'No Saved Jobs Yet',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasAnySaved
                  ? 'Try a different filter, or clear it to see everything you\'ve saved.'
                  : 'Tap the bookmark icon on any job to save it here for later.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textTertiary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            if (!hasAnySaved)
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Browse Jobs',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Shared bits ──

  String _periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr';
    if (p.contains('week')) return 'wk';
    if (p.contains('month')) return 'mo';
    return p.isEmpty ? 'mo' : p;
  }

  Widget _buildBookmarkButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Icon(
          Icons.bookmark_rounded,
          size: 17,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLogoFallback(String companyName, {double size = 46}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Center(
        child: Text(
          companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // Color-codes tags by keyword — same convention used on the Home screen's
  // job cards, so Saved Jobs feels consistent with the rest of the app.
  Widget _buildTag(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    final lower = text.toLowerCase();
    Color bg;
    Color fg;
    if (lower.contains('remote')) {
      bg = AppColors.infoBackground;
      fg = AppColors.info;
    } else if (lower.contains('onsite') || lower.contains('on-site')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else if (lower.contains('hybrid')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
    } else if (lower.contains('full')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
    } else if (lower.contains('part')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else if (lower.contains('contract') || lower.contains('senior')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else {
      bg = AppColors.primaryLight;
      fg = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
