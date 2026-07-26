import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/job_recent_model.dart';
import 'package:jobber_city/models/role/seeker/job_recommended_model.dart';

part 'job_detail_binding.dart';
part 'job_detail_controller.dart';

/// Job Detail screen.
///
/// Reached via `Get.toNamed(AppRoutes.jobDetail, arguments: job)` where
/// `job` may be either a `JobRecommendedModel` or a `JobRecentModel` — both
/// expose the same core fields (title, salary range, company, location,
/// employment type, isSaved); `JobRecentModel` additionally has `workType`.
/// `JobDetailController` normalizes whichever type comes in, so this view
/// doesn't care which one it received.
///
/// NOTE: neither model currently carries a job description, requirements,
/// or benefits from the API. Those sections below use placeholder copy —
/// swap them for real fields once the backend/model expose them.
class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompanyCard(),
                        const SizedBox(height: 22),
                        _buildInfoStatsRow(),
                        const SizedBox(height: 26),
                        _buildSectionTitle("Job Description"),
                        const SizedBox(height: 10),
                        _buildDescription(),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Requirements"),
                        const SizedBox(height: 10),
                        _buildRequirements(),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Benefits"),
                        const SizedBox(height: 12),
                        _buildBenefits(),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Location"),
                        const SizedBox(height: 10),
                        _buildLocationCard(),
                        // Leave room so content isn't hidden behind the
                        // sticky bottom apply bar.
                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  // ── Header: gradient banner with back + share/bookmark controls ──
  Widget _buildHeader(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 70),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Get.back(result: controller.currentJob),
          ),
          const Text(
            "Job Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          _circleIconButton(
            icon: Icons.ios_share_rounded,
            onTap: () {
              Get.snackbar(
                'Share',
                'Sharing isn\'t wired up yet',
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppColors.primaryLight,
                colorText: AppColors.primary,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // ── Company card: logo, title, company name, bookmark ──
  Widget _buildCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Obx(
                () => controller.logoUrl.value.isNotEmpty
                    ? Image.network(
                        controller.logoUrl.value,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _logoFallback(),
                      )
                    : _logoFallback(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.title.value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.companyName.value,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          controller.location.value,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: controller.toggleSave,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    controller.isSaved.value
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    key: ValueKey(controller.isSaved.value),
                    size: 19,
                    color: controller.isSaved.value
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoFallback() {
    return Obx(
      () => Center(
        child: Text(
          controller.companyName.value.isNotEmpty
              ? controller.companyName.value[0].toUpperCase()
              : 'C',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // ── Quick stats row: salary / employment type / work type ──
  Widget _buildInfoStatsRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _statChip(
              icon: Icons.payments_rounded,
              label: controller.salaryText,
              highlight: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statChip(
              icon: Icons.work_outline_rounded,
              label: controller.employmentType.value.isNotEmpty
                  ? controller.employmentType.value
                  : '—',
            ),
          ),
          if (controller.workType.value.isNotEmpty) ...[
            const SizedBox(width: 10),
            Expanded(
              child: _statChip(
                icon: Icons.apartment_rounded,
                label: controller.workType.value,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryLight
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight ? AppColors.primary : AppColors.textTertiary,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ── Description — placeholder copy; the job models don't carry a
  // description field from the API yet. ──
  Widget _buildDescription() {
    return Obx(() {
      final expanded = controller.isDescriptionExpanded.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.placeholderDescription,
            maxLines: expanded ? null : 4,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => controller.isDescriptionExpanded.toggle(),
            child: Text(
              expanded ? "Show less" : "Read more",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    });
  }

  // ── Requirements — placeholder bullet list. ──
  Widget _buildRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.placeholderRequirements
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Benefits — placeholder wrap of pills. ──
  Widget _buildBenefits() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: controller.placeholderBenefits.map((benefit) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.successBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                benefit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationCard() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.map_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.location.value.isNotEmpty
                    ? controller.location.value
                    : "Location not specified",
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sticky bottom bar: bookmark + Apply Now ──
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => GestureDetector(
              onTap: controller.toggleSave,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  controller.isSaved.value
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: controller.isSaved.value
                      ? AppColors.primary
                      : AppColors.textHint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: controller.hasApplied.value ? null : controller.applyNow,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: controller.hasApplied.value
                        ? AppColors.success
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: controller.hasApplied.value
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: controller.isApplying.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.hasApplied.value
                                  ? Icons.check_circle_rounded
                                  : Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.hasApplied.value
                                  ? "Applied"
                                  : "Apply Now",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
