import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/routes/app_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../core/api/services/role/employer/company_profile_services.dart';
import '../../../../models/role/employer/company_model.dart';

part 'employer_profile_binding.dart';
part 'employer_profile_controller.dart';

class EmployerProfileView extends GetView<EmployerProfileViewController> {
  const EmployerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // ពណ៌ផ្ទៃខាងក្រោយប្រផេះស្រាលៗ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Company Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4f7df7)),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchMyProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // ── ១. ផ្នែក Header (Cover & Logo) ──
              _buildProfileHeader(),

              const SizedBox(height: 20),

              // ── ២. ផ្នែក Quick Stats ──
              _buildQuickStats(),

              const SizedBox(height: 24),

              // ── ៣. ផ្នែក Settings & Menu ──
              _buildMenuSection(
                title: "General Settings",
                items: [
                  _buildMenuItem(
                    icon: LucideIcons.building2,
                    title: "Company Details",
                    onTap: () {
                      Get.toNamed(AppRoutes.companyDetail);
                    },
                  ),

                  _buildMenuItem(
                    icon: LucideIcons.lock,
                    title: "Change Password",
                    onTap: () {
                      Get.toNamed(AppRoutes.changePassword);
                    },
                  ),

                  _buildMenuItem(
                    icon: LucideIcons.bell,
                    title: "Notifications",
                    onTap: () {
                      Get.toNamed(AppRoutes.notificationEmployer);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── ៤. ផ្នែក Support ──
              _buildMenuSection(
                title: "Support & Legal",
                items: [
                  _buildMenuItem(
                    icon: LucideIcons.helpCircle,
                    title: "Help Center & FAQ",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: LucideIcons.shieldCheck,
                    title: "Terms & Privacy Policy",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ── ៥. ផ្នែក Danger Zone (Log Out) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.find<AuthController>().logout();
                  },
                  icon: const Icon(LucideIcons.logOut, color: Colors.redAccent),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(
                      color: Colors.redAccent.shade100,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // ==========================================
  // ── មុខងារជំនួយ (Helper Widgets) ខាងក្រោម ──
  // ==========================================

  Widget _buildProfileHeader() {
    final profile = controller.companyProfile.value;
    final companyName = profile?.companyName ?? 'Company Name';
    final hasLogo = profile?.logoUrl != null && profile!.logoUrl!.isNotEmpty;

    final industryName = controller.getIndustryName(profile?.industryId);
    final provinceName = controller.getProvinceName(profile?.provinceId);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // ផ្នែក Cover និង Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Cover Photo Placeholder
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4f7df7), Color(0xFF8faaf9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Company Logo
              Positioned(
                bottom: -40,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFF0F4FF),
                    backgroundImage: hasLogo
                        ? NetworkImage(profile.logoUrl!)
                        : null,
                    child: hasLogo
                        ? null
                        : const Icon(
                            LucideIcons.building,
                            size: 40,
                            color: Color(0xFF4f7df7),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                companyName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (profile?.isVerified == true) ...[
                const SizedBox(width: 6),
                const Icon(
                  LucideIcons.badgeCheck,
                  color: Colors.blue,
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$industryName • $provinceName",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            "Company Size: ${profile?.companySize ?? 'N/A'}",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          // ប៊ូតុង Edit Profile
          OutlinedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.editProfileEmployer);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4f7df7),
              side: const BorderSide(color: Color(0xFF4f7df7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard("Active Jobs", "15"),
          const SizedBox(width: 16),
          _buildStatCard("Candidates", "120"),
          // const SizedBox(width: 12),
          // _buildStatCard("Views", "850"),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4f7df7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF4f7df7)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
