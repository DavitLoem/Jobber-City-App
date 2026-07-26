import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../controllers/location_controller.dart';
import '../../../../../controllers/master_data_controller.dart';
import '../../../../../core/api/services/role/employer/job_service.dart';
import '../../../../../models/role/employer/company_model.dart';
import '../../../../../models/role/employer/job_model.dart';
import '../employer_profile_view.dart';

// កុំភ្លេច Import Controller ផ្សេងៗដែលពាក់ព័ន្ធ (MasterData, Location, EmployerProfile...)

part 'company_detail_binding.dart';
part 'company_detail_controller.dart';

class CompanyDetailView extends GetView<CompanyDetailViewController> {
  const CompanyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ទាញយក Profile ពី Controller មកប្រើ
    final profile = controller.companyProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
            _buildCompanyHeader(profile),

            // ── ២. About Company ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🎯 ភ្ជាប់ Description (បើគ្មាន បង្ហាញអត្ថបទលំនាំដើម)
                  Text(
                    profile?.description != null &&
                            profile!.description.isNotEmpty
                        ? profile.description
                        : "No description available.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🎯 ភ្ជាប់ ទីតាំងពិតប្រាកដ
                  Obx(() {
                    // គ្រាន់តែហៅវាចោល ដើម្បីឱ្យ Obx ដឹងថាត្រូវស្តាប់តាមអថេរនេះ
                    final _ = controller.isLocationLoaded.value;

                    return _buildContactInfoRow(
                      LucideIcons.mapPin,
                      controller.getLocationName(
                        profile?.provinceId,
                        profile?.districtId,
                      ),
                    );
                  }),

                  // 🎯 ភ្ជាប់ Website (លាក់ចោលប្រសិនបើគ្មាន)
                  if (profile?.websiteUrl != null &&
                      profile!.websiteUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildContactInfoRow(
                      LucideIcons.globe,
                      profile.websiteUrl!,
                      isLink: true,
                    ),
                  ],
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            // ── ៣. Active Jobs (ត្រៀមសម្រាប់ API) ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (controller.isLoadingJobs.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: Color(0xFF4f7df7),
                      ),
                    ),
                  );
                }

                if (controller.activeJobs.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Active Jobs",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "No active jobs at the moment.",
                          style: TextStyle(color: Colors.grey.shade500),
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
                        const Text(
                          "Active Jobs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        // 🎯 បង្ហាញចំនួនការងារក្លែងក្លាយសិន ត្រៀមដូរទៅ length របស់ API
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EEFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${controller.activeJobs.length}", // នឹងប្តូរតាម API
                              style: const TextStyle(
                                color: Color(0xFF4f7df7),
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
                            color: Color(0xFF4f7df7),
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

  // 🎯 បញ្ជូន profile ចូលដើម្បីទាញរូបភាព និងឈ្មោះ
  Widget _buildCompanyHeader(CompanyProfileModel? profile) {
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
            // ប្រើរូបពិតបើមាន, បើគ្មានប្រើ Gradient ពណ៌ខៀវ
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFFF0F4FF),
                  // ប្រើ Logo ពិតបើមាន, បើគ្មានប្រើ Icon
                  backgroundImage: hasLogo
                      ? NetworkImage(profile.logoUrl!)
                      : null,
                  child: !hasLogo
                      ? const Icon(
                          LucideIcons.building,
                          size: 35,
                          color: Color(0xFF4f7df7),
                        )
                      : null,
                ),
              ),

              // ឈ្មោះ និង ឧស្សាហកម្ម
              Transform.translate(
                offset: const Offset(0, -30),
                child: Column(
                  children: [
                    Text(
                      profile?.companyName ?? "Unknown Company",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.getIndustryName(profile?.industryId),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Expanded(
          // រុំ Expanded ដើម្បីឱ្យវាធ្លាក់បន្ទាត់ស្អាតបើអត្ថបទវែង
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isLink ? const Color(0xFF4f7df7) : Colors.grey.shade700,
              fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockJobCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.briefcase,
              color: Color(0xFF4f7df7),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: Colors.grey.shade300, size: 20),
        ],
      ),
    );
  }
}
