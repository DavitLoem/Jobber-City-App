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
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;
    final profile = controller.companyProfile;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.3),
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
            // ── ១. Header (Cover, Logo, ឈ្មោះ) ──
            _buildCompanyHeader(profile, isDark),

            // ── ២. About Company ──
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
                      color: isDark
                          ? Colors.white
                          : Colors.black87, // 🟢 Dynamic Text
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
                          : Colors.grey.shade700, // 🟢 Dynamic Subtext
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
                      isDark,
                    );
                  }),

                  if (profile?.websiteUrl != null &&
                      profile!.websiteUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildContactInfoRow(
                      LucideIcons.globe,
                      profile.websiteUrl!,
                      isDark,
                      isLink: true,
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
            // ── ៣. Active Jobs (ត្រៀមសម្រាប់ API) ──
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
                          color: isDark
                              ? Colors.white
                              : Colors.black87, // 🟢 Dynamic Text
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "No active jobs at the moment.".tr, // 🟢 Added .tr
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : Colors.grey.shade500,
                          ), // 🟢 Dynamic Subtext
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
                            color: isDark
                                ? Colors.white
                                : Colors.black87, // 🟢 Dynamic Text
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
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : const Color(
                                      0xFFE8EEFF,
                                    ), // 🟢 Dynamic Label BG
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${controller.activeJobs.length}",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.blueAccent
                                    : AppColors.primary, // 🟢 Dynamic Text
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

  Widget _buildCompanyHeader(CompanyProfileModel? profile, bool isDark) {
    final hasBanner =
        profile?.bannerUrl != null && profile!.bannerUrl!.isNotEmpty;
    final hasLogo = profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Cover ──
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
                ? const LinearGradient(
                    colors: [Color(0xFF4f7df7), Color(0xFF8faaf9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
        ),

        // ── Information Box ──
        Container(
          margin: const EdgeInsets.only(top: 180, left: 20, right: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : Colors.white, // 🟢 Dynamic Profile Box BG
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.3 : 0.05,
                ), // 🟢 Dynamic Shadow
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Logo
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceElevated
                      : Colors.white, // 🟢 Dynamic Border matching BG
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: isDark
                      ? AppColors.darkInputBackground
                      : const Color(0xFFF0F4FF), // 🟢 Dynamic Avatar BG
                  backgroundImage: hasLogo
                      ? NetworkImage(profile.logoUrl!)
                      : null,
                  child: !hasLogo
                      ? Icon(
                          LucideIcons.building,
                          size: 35,
                          color: isDark
                              ? Colors.blueAccent
                              : AppColors.primary, // 🟢 Dynamic Icon
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
                        color: isDark
                            ? Colors.white
                            : Colors.black87, // 🟢 Dynamic Text
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
                            : Colors.grey.shade600, // 🟢 Dynamic Text
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
    String text,
    bool isDark, {
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkIconSecondary : Colors.grey.shade500,
        ), // 🟢 Dynamic Icon Color
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isLink
                  ? (isDark
                        ? Colors.blueAccent
                        : AppColors.primary) // 🟢 Dynamic Link Text
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700), // 🟢 Dynamic Detail Text
              fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockJobCard(String title, String subtitle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors.white, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
        ), // 🟢 Dynamic Card Border
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : const Color(0xFFF0F4FF), // 🟢 Dynamic Icon Wrap BG
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.briefcase,
              color: isDark
                  ? Colors.blueAccent
                  : AppColors.primary, // 🟢 Dynamic Icon
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
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // 🟢 Dynamic Job Title
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade500,
                    fontSize: 13,
                  ), // 🟢 Dynamic Job Location/Sub
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
