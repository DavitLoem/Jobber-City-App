import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recent_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recommended_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/models/role/seeker/job_recent_model.dart';
import 'package:jobber_city/models/role/seeker/job_recommended_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

const _recentFilters = ["All", "Design", "Technology", "Finance"];

/// Auto-scrolling promo banner slider shown at the top of the seeker home
/// screen — e.g. "Find Your Dream Career". Purely static UI content (not
/// backed by any API/model), with a looping PageView + dot indicators.
class _PromoBannerSlider extends StatefulWidget {
  const _PromoBannerSlider();

  @override
  State<_PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _BannerData {
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final List<Color> colors;
}

const _promoBanners = [
  _BannerData(
    title: "Find Your Dream\nCareer",
    subtitle: "Explore thousands of verified companies hiring today.",
    buttonText: "Explore Jobs",
    colors: [AppColors.primary, AppColors.secondary],
  ),
  _BannerData(
    title: "Build A Standout\nResume",
    subtitle: "Get noticed by recruiters with a polished, ATS-ready CV.",
    buttonText: "Build Resume",
    colors: [AppColors.primaryDark, AppColors.primary],
  ),
  _BannerData(
    title: "Track Every\nApplication",
    subtitle: "Stay on top of interviews and offers, all in one place.",
    buttonText: "View Progress",
    colors: [AppColors.secondary, AppColors.accent],
  ),
];

class _PromoBannerSliderState extends State<_PromoBannerSlider> {
  // Start deep into a virtually-infinite range so we can page both
  // directions without a visible "jump" back to the start.
  static const int _initialPage = 5000;

  late final PageController _pageController = PageController(
    viewportFraction: 1,
    initialPage: _initialPage,
  );
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next =
          (_pageController.page ?? _initialPage.toDouble()).round() + 1;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18),
        SizedBox(
          height: 192,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() => _currentIndex = page % _promoBanners.length);
            },
            itemBuilder: (context, page) {
              final banner = _promoBanners[page % _promoBanners.length];
              return _buildBannerCard(banner);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (i) {
            final isActive = i == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.pageIndicatorActive
                    : AppColors.pageIndicatorInactive,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(_BannerData banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.colors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: banner.colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative floating circles, echoes the reference design.
          Positioned(
            right: -10,
            top: -18,
            child: _decorCircle(70, Colors.white.withOpacity(0.10)),
          ),
          Positioned(
            right: 30,
            top: 6,
            child: _decorCircle(22, Colors.white.withOpacity(0.16)),
          ),
          Positioned(
            right: 4,
            bottom: -14,
            child: _decorCircle(40, Colors.white.withOpacity(0.12)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 190,
                child: Text(
                  banner.subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      banner.buttonText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: banner.colors.first,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: banner.colors.first,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: RefreshIndicator(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(context),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PromoBannerSlider(),
                    const SizedBox(height: 28),
                    _buildSectionHeader("Recommended For You"),
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
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero header: gradient card (avatar, greeting, bell) with the
  // search bar floating half over its rounded bottom edge ──
  Widget _buildHeroSection(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, topInset + 18, 20, 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.78)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildHeroTopRow(),
        ),
        Positioned(left: 20, right: 20, bottom: -28, child: _buildSearchBar()),
      ],
    );
  }

  Widget _buildHeroTopRow() {
    return Row(
      children: [
        _AvatarTapScale(
          onTap: () => Get.toNamed(
            '/edit-profile',
          )?.then((_) => controller.fetchProfileRaw()),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const _ShimmerBox(
                width: 54,
                height: 54,
                borderRadius: 27,
                baseColor: Color(0x40FFFFFF), // translucent white on blue
              );
            }
            return Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.6,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: controller.profileImageUrl.value.isNotEmpty
                      ? Image.network(
                          controller.profileImageUrl.value,
                          width: 49,
                          height: 49,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildUserFallback();
                          },
                        )
                      : _buildUserFallback(),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    width: 90,
                    height: 12,
                    borderRadius: 6,
                    baseColor: Color(0x40FFFFFF),
                  ),
                  SizedBox(height: 8),
                  _ShimmerBox(
                    width: 150,
                    height: 16,
                    borderRadius: 6,
                    baseColor: Color(0x40FFFFFF),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.getGreeting()} 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.firstName.value.isNotEmpty
                      ? "${controller.firstName.value} ${controller.lastName.value}"
                      : "Guest",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }),
        ),
        // Notification bell — placeholder only (no notifications screen
        // wired up yet). NOTE: this used to call
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFallback() {
    // If we actually have a name, show its initial. Otherwise (profile
    // still loading with no cached name, fetch failed, or the API
    // returned no data) fall back to a generic person icon instead of a
    // meaningless "U" placeholder letter.
    if (controller.firstName.value.isNotEmpty) {
      return Center(
        child: Text(
          controller.firstName.value[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.person_rounded, size: 26, color: AppColors.primary),
    );
  }

  // ── Floating search bar (sits half over the hero's bottom edge) ──
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Search for a job or Company...',
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 16,
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
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Recent job filter chips — actually filters the list below ──
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
          job.employmentType.toLowerCase().contains(query) ||
          job.workType.toLowerCase().contains(query);
    }).toList();
  }

  // ── Recommended jobs (horizontal cards) ──
  Widget _buildJobRecommended() {
    return SizedBox(
      height: 226,
      child: Obx(() {
        if (controller.isRecommendedLoading.value) {
          return _buildRecommendedSkeleton();
        }
        if (controller.recommendedJobs.isEmpty) {
          return _buildInlineEmptyState('No recommended jobs found');
        }
        // +1 so the slider shows one extra card after the real jobs —
        // a static "See more" card that isn't backed by any API data.
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.recommendedJobs.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            if (index == controller.recommendedJobs.length) {
              return _buildSeeMoreRecommendedCard();
            }
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
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (context, index) =>
          _ShimmerBox(width: 250, height: 226, borderRadius: 20),
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
              if (i != -1) controller.recommendedJobs[i] = updatedJob;
            }
          });
        },
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(14),
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
                  _buildCompanyLogo(job.logoUrl, job.companyName, size: 44),
                  const Spacer(),
                  _buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecommendedJob(index),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                job.companyName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      job.location,
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
              const SizedBox(height: 10),
              _buildTag(job.employmentType),
              const Spacer(),
              Text(
                "\$${job.minSalary.toInt()} - \$${job.maxSalary.toInt()}/${_periodShort(job.salaryPeriod)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Static "see more" card appended to the end of the Recommended slider.
  // Not tied to any job data from the API — just a UI affordance that
  // routes to wherever "See All" goes.
  Widget _buildSeeMoreRecommendedCard() {
    return GestureDetector(
      onTap: () {
        // TODO: point this at the actual "see all recommended jobs" route
        Get.snackbar(
          'Recommended Jobs',
          'See all recommended jobs',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryLight,
          colorText: AppColors.primary,
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "See More",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "Explore all jobs",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent jobs (vertical cards, filtered) ──
  Widget _buildJobRecent() {
    return Obx(() {
      if (controller.isRecentLoading.value) {
        return Column(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ShimmerBox(
                width: double.infinity,
                height: 168,
                borderRadius: 20,
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
        itemCount: filtered.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == filtered.length) {
            return _buildSeeMoreRecentCard();
          }
          final job = filtered[index];
          final realIndex = controller.recentJobs.indexOf(job);
          return _buildRecentJobCard(job, realIndex, index);
        },
      );
    });
  }

  // Static "see more" row appended after the Recent Jobs list — same idea
  // as the Recommended slider's card: not backed by API data, just a UI
  // affordance pointing to wherever "See All" should go.
  Widget _buildSeeMoreRecentCard() {
    return GestureDetector(
      onTap: () {
        // TODO: point this at the actual "see all recent jobs" route
        Get.snackbar(
          'Recent Jobs',
          'See all recent jobs',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryLight,
          colorText: AppColors.primary,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "See More",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentJobCard(JobRecentModel job, int index, int staggerIndex) {
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
              if (i != -1) controller.recentJobs[i] = updatedJob;
            }
          });
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
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyLogo(job.logoUrl, job.companyName, size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          job.companyName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildBookmarkButton(
                    isSaved: job.isSaved,
                    onTap: () => controller.toggleSaveRecentJob(index),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      job.location,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.north_east_rounded,
                    size: 13,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "\$${job.maxSalary.toInt()}/${_periodShort(job.salaryPeriod)}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTag(job.employmentType),
                        _buildTag(job.workType),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Apply Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
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

  // ── Shared bits ──

  String _periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr';
    if (p.contains('week')) return 'wk';
    if (p.contains('month')) return 'mo';
    return p.isEmpty ? 'mo' : p;
  }

  Widget _buildBookmarkButton({
    required bool isSaved,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(9),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(isSaved),
            size: 17,
            color: isSaved ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(
    String logoUrl,
    String companyName, {
    double size = 46,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.26),
        child: logoUrl.isNotEmpty
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildLogoFallback(companyName),
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
          fontSize: 17,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // Color-codes tags by keyword (Remote/Onsite/Hybrid/Full-time/Part-time/
  // Contract/Senior/Junior...) so different tag types stand out, same idea
  // as the reference design's multi-colored pills.
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
    } else if (lower.contains('junior') || lower.contains('entry')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
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

/// Small tap-scale wrapper for the avatar.
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

/// Pulsing placeholder box used while data is loading — works on light
/// surfaces (default grey) or on colored/gradient surfaces like the hero
/// header (pass a translucent white instead).
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    this.baseColor,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;

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
              color: widget.baseColor ?? AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
