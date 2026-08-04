import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class ProfileFilledMockupView extends StatelessWidget {
  const ProfileFilledMockupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FB,
      ), // ពណ៌ផ្ទៃខាងក្រោយស្រាលជាងមុនបន្តិច
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile Preview',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 ១. គំរូបង្ហាញ CV ដែលបាន Upload រួច
            _buildDataCard(
              title: "Resume (CV)",
              actionIcon: Icons.edit_outlined,
              onActionTap: () {},
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sles_Rofath_CV_2026.pdf",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Uploaded on Oct 24, 2026 • 2.4 MB",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🎯 ២. គំរូបង្ហាញ Work Experience ដែលបានទាញយកដោយ AI
            _buildDataCard(
              title: "Work Experience",
              actionIcon: Icons.add,
              onActionTap: () {},
              child: Column(
                children: [
                  _buildExperienceItem(
                    jobTitle: "Senior Flutter Developer",
                    company: "Tech Solutions App",
                    date: "Jan 2024 - Present",
                    isLast: false,
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  _buildExperienceItem(
                    jobTitle: "Mobile App Developer",
                    company: "Sabaicode",
                    date: "Mar 2021 - Dec 2023",
                    isLast: true,
                    onEdit: () {},
                    onDelete: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🎯 ៣. គំរូបង្ហាញ Skills
            _buildDataCard(
              title: "Skills",
              actionIcon: Icons.edit_outlined,
              onActionTap: () {},
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSkillChip("Flutter"),
                  _buildSkillChip("Dart"),
                  _buildSkillChip("Firebase"),
                  _buildSkillChip("RESTful API"),
                  _buildSkillChip("UI/UX Design"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── វីដជេត (Widget) ជំនួយសម្រាប់បង្កើត Card ──
  Widget _buildDataCard({
    required String title,
    required Widget child,
    required IconData actionIcon,
    required VoidCallback onActionTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: onActionTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(actionIcon, size: 20, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String jobTitle,
    required String company,
    required String date,
    required bool isLast,
    required VoidCallback onEdit, // 🎯 ទទួលយកមុខងារ Edit
    required VoidCallback onDelete, // 🎯 ទទួលយកមុខងារ Delete
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work_outline, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200, height: 1),
                ],
              ],
            ),
          ),
          // 🎯 បន្ថែមប៊ូតុង Menu (3 ចំណុច) ដែលលាក់ភាពរញ៉េរញ៉ៃ
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }
}
