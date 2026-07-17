import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recent_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recommended_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/models/role/seeker/job_recent_model.dart';
import 'package:jobber_city/models/role/seeker/job_recommended_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

const _recentFilters = ["All", "Design", "Technology", "Finance"];

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            controller.fetchProfileRaw();
            controller.fetchJobRecommended();
            controller.fetchJobRecent();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 22),
                  _buildSearchBar(),
                  const SizedBox(height: 26),
                  _buildSectionHeader("Recommendation"),
                  const SizedBox(height: 16),
                  _buildJobRecommended(),
                  const SizedBox(height: 32),
                  _buildSectionHeader("Recent Jobs"),
                  const SizedBox(height: 16),
                  _buildRecentFilters(),
                  const SizedBox(height: 16),
                  _buildJobRecent(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header: avatar + greeting + notification bell ──
  Widget _buildHeader() {
    return Row(
      children: [
        _AvatarTapScale(
          onTap: () => Get.toNamed(
            '/edit-profile',
          )?.then((_) => controller.fetchProfileRaw()),
          child: Obx(
            () => Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.4),
                  ],
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: AppColors.primaryLight,
                  child: controller.profileImageUrl.value.isNotEmpty
                      ? Image.network(
                          controller.profileImageUrl.value,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildUserFallback();
                          },
                        )
                      : _buildUserFallback(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.getGreeting()} 👋",
                  style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.firstName.value.isNotEmpty
                      ? "${controller.firstName.value} ${controller.lastName.value}"
                      : "Loading...",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
        ),
        // Notification bell — purely a placeholder for now (no notifications
        // screen wired up yet). NOTE: previously this button called
        // Get.find<AuthController>().logout() by mistake, so tapping what
        // looked like a notification icon silently signed the user out.
        // That call has been removed.
        GestureDetector(
          onTap: () {
            Get.snackbar(
              'Notifications',
              'No new notifications',
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColors.primaryLight,
              colorText: AppColors.primary,
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFallback() {
    return const Center(
      child: Icon(Icons.person_rounded, size: 28, color: AppColors.primary),
    );
  }

  // ── Search bar ──
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a job or Company...',
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 14,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "See All",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Recent job filter chips — now actually filters the list below ──
  Widget _buildRecentFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recentFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                controller.selectedRecentFilterIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectedRecentFilterIndex.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBorder,
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
                  _recentFilters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  List<JobRecentModel> _filteredRecentJobs() {
    final selected = _recentFilters[controller.selectedRecentFilterIndex.value];
    if (selected == "All") return controller.recentJobs;
    final query = selected.toLowerCase();
    return controller.recentJobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.companyName.toLowerCase().contains(query) ||
          job.employmentType.toLowerCase().contains(query) ||
          job.workType.toLowerCase().contains(query);
    }).toList();
  }

  // ── Recommended jobs (horizontal) ──
  Widget _buildJobRecommended() {
    return SizedBox(
      height: 250,
      child: Obx(() {
        if (controller.isRecommendedLoading.value) {
          return _buildRecommendedSkeleton();
        }
        if (controller.recommendedJobs.isEmpty) {
          return _buildInlineEmptyState('No recommended jobs found');
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.recommendedJobs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final job = controller.recommendedJobs[index];
            return _buildRecommendedJobCard(job, index, index);
          },
        );
      }),
    );
  }

  Widget _buildRecommendedSkeleton() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) =>
          _ShimmerBox(width: 280, height: 250, borderRadius: 24),
    );
  }

  Widget _buildRecommendedJobCard(
    JobRecommendedModel job,
    int index,
    int staggerIndex,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (staggerIndex * 80).clamp(0, 320)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((updatedJob) {
            if (updatedJob != null) {
              int i = controller.recommendedJobs.indexOf(job);
              if (i != -1) {
                controller.recommendedJobs[i] = updatedJob;
              }
            }
          });
        },
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
                children: [
                  _buildCompanyLogo(job.logoUrl, job.companyName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecommendedJob(index),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "\$${job.minSalary.toInt()} - \$${job.maxSalary.toInt()} /${job.salaryPeriod.toLowerCase()}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(children: [_buildTag(job.employmentType)]),
            ],
          ),
        ),
      ),
    );
  }

  // ── Recent jobs (vertical, filtered) ──
  Widget _buildJobRecent() {
    return Obx(() {
      if (controller.isRecentLoading.value) {
        return Column(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ShimmerBox(
                width: double.infinity,
                height: 150,
                borderRadius: 24,
              ),
            ),
          ),
        );
      }

      final filtered = _filteredRecentJobs();

      if (filtered.isEmpty) {
        return _buildInlineEmptyState(
          controller.recentJobs.isEmpty
              ? 'No recent jobs found'
              : 'No jobs match this filter',
          topPadding: 20,
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final job = filtered[index];
          final realIndex = controller.recentJobs.indexOf(job);
          return _buildRecentJobCard(job, realIndex, index);
        },
      );
    });
  }

  Widget _buildRecentJobCard(JobRecentModel job, int index, int staggerIndex) {
    // Resolve the real index in the source list so bookmark toggles the
    // correct job even when a filter is active.
    final realIndex = controller.recentJobs.indexOf(job);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (staggerIndex * 60).clamp(0, 300)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetail, arguments: job)?.then((updatedJob) {
            if (updatedJob != null) {
              int i = controller.recentJobs.indexOf(job);
              if (i != -1) {
                controller.recentJobs[i] = updatedJob;
              }
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCompanyLogo(job.logoUrl, job.companyName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecentJob(realIndex),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "\$${job.minSalary} - \$${job.maxSalary} /${job.salaryPeriod.toLowerCase()}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared bits ──

  Widget _buildBookmarkButton({
    required bool isSaved,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(isSaved),
            color: isSaved ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(String logoUrl, String companyName) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: logoUrl.isNotEmpty
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildLogoFallback(companyName);
                },
              )
            : _buildLogoFallback(companyName),
      ),
    );
  }

  Widget _buildLogoFallback(String companyName) {
    return Center(
      child: Text(
        companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInlineEmptyState(String message, {double topPadding = 0}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 32,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small tap-scale wrapper for the avatar — same interaction pattern used
/// on other profile/avatar pickers across the app.
class _AvatarTapScale extends StatefulWidget {
  const _AvatarTapScale({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_AvatarTapScale> createState() => _AvatarTapScaleState();
}

class _AvatarTapScaleState extends State<_AvatarTapScale> {
  double _scale = 1.0;

  void _setScale(double value) => setState(() => _scale = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setScale(0.92),
      onTapUp: (_) => _setScale(1.0),
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Simple pulsing placeholder box used while job lists are loading,
/// instead of a bare spinner.
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
