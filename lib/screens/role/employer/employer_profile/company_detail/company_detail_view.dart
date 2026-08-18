import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../controllers/location_controller.dart';
import '../../../../../controllers/master_data_controller.dart';
import '../../../../../core/api/services/role/employer/job_service.dart';
import '../../../../../models/role/employer/company_model.dart';
import '../../../../../models/role/employer/job_model.dart';
import '../employer_profile_view.dart';

part 'company_detail_binding.dart';
part 'company_detail_controller.dart';

class CompanyDetailView extends GetView<CompanyDetailViewController> {
  const CompanyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.companyProfile;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(
              alpha: 0.3,
            ), // 🟢 Updated opacity
            child: IconButton(
              icon: const Icon(
                LucideIcons.arrowLeft,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyHeader(profile, theme, isDark), // 🟢 Passed Context

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Us".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    profile?.description != null &&
                            profile!.description.isNotEmpty
                        ? profile.description
                        : "No description available.".tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.grey.shade700, // 🟢 Dynamic Text
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Obx(() {
                    final _ = controller.isLocationLoaded.value;

                    return _buildContactInfoRow(
                      LucideIcons.mapPin,
                      controller.getLocationName(
                        profile?.provinceId,
                        profile?.districtId,
                      ),
                      isDark: isDark,
                    );
                  }),

                  if (profile?.websiteUrl != null &&
                      profile!.websiteUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildContactInfoRow(
                      LucideIcons.globe,
                      profile.websiteUrl!,
                      isLink: true,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            ), // 🟢 Dynamic Divider

            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (controller.isLoadingJobs.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                if (controller.activeJobs.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Jobs".tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme
                              .textTheme
                              .bodyLarge
                              ?.color, // 🟢 Dynamic Title
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "No active jobs at the moment.".tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey.shade500,
                          ), // 🟢 Dynamic Text
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Jobs".tr, // 🟢 Added .tr
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme
                                .textTheme
                                .bodyLarge
                                ?.color, // 🟢 Dynamic Title
                          ),
                        ),

                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ) // 🟢 Updated opacity
                                  : const Color(
                                      0xFFE8EEFF,
                                    ), // 🟢 Dynamic Badge BG
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${controller.activeJobs.length}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      final _ = controller.isLocationLoaded.value;

                      return Column(
                        children: controller.activeJobs.map((job) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildMockJobCard(
                              job.title,
                              "${controller.getEmploymentTypeName(job.employmentTypeId)} • ${controller.getLocationName(job.provinceId, job.districtId)}",
                              theme,
                              isDark,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    if (controller.isLoadingMoreJobs.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(
    CompanyProfileModel? profile,
    ThemeData theme,
    bool isDark,
  ) {
    final hasBanner =
        profile?.bannerUrl != null && profile!.bannerUrl!.isNotEmpty;
    final hasLogo = profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            image: hasBanner
                ? DecorationImage(
                    image: NetworkImage(profile.bannerUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: !hasBanner
                ? LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.primary.withValues(
                              alpha: 0.8,
                            ), // 🟢 Updated opacity
                            AppColors.primary.withValues(
                              alpha: 0.4,
                            ), // 🟢 Updated opacity
                          ] // 🟢 Dynamic Gradient
                        : [const Color(0xFF4f7df7), const Color(0xFF8faaf9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 180, left: 20, right: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor, // 🟢 Dynamic Info BG
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : Colors.transparent,
            ), // 🟢 Dynamic Border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.2 : 0.05, // 🟢 Updated opacity
                ), // 🟢 Adjusted shadow
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.cardColor, // 🟢 Dynamic Ring BG
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceElevated
                      : const Color(0xFFF0F4FF), // 🟢 Dynamic Avatar BG
                  backgroundImage: hasLogo
                      ? NetworkImage(profile.logoUrl!)
                      : null,
                  child: !hasLogo
                      ? const Icon(
                          LucideIcons.building,
                          size: 35,
                          color: AppColors.primary,
                        )
                      : null,
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -30),
                child: Column(
                  children: [
                    Text(
                      profile?.companyName ??
                          "Unknown Company".tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Name
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.getIndustryName(profile?.industryId),
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey.shade600, // 🟢 Dynamic Subtitle
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoRow(
    IconData icon,
    String text, {
    bool isLink = false,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade500,
        ), // 🟢 Dynamic Icon
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isLink
                  ? (isDark
                        ? Colors.blueAccent
                        : AppColors.primary) // 🟢 Dynamic Link
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700), // 🟢 Dynamic Text
              fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockJobCard(
    String title,
    String subtitle,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Border
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(
                      alpha: 0.15,
                    ) // 🟢 Updated opacity
                  : const Color(0xFFF0F4FF), // 🟢 Dynamic Icon BG
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.briefcase,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : Colors.grey.shade500,
                    fontSize: 13,
                  ), // 🟢 Dynamic Subtitle
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            color: isDark ? AppColors.darkIconSecondary : Colors.grey.shade300,
            size: 20,
          ), // 🟢 Dynamic Chevron
        ],
      ),
    );
  }
}
