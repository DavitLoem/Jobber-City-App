import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobDetailView extends StatelessWidget {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.edit, color: Colors.black87),
            onPressed: () {
              // មុខងារ Edit Job
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2, color: Colors.black87),
            onPressed: () {
              // មុខងារ Share
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ១. Header ──
                _buildHeader(),
                const SizedBox(height: 24),

                // ── ២. Tags & Highlights (ផ្អែកលើ JSON) ──
                _buildTagsSection(),
                const SizedBox(height: 24),

                // ── ៣. ព័ត៌មានការងារ (Working Hours, Days, Headcount) ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        LucideIcons.calendarDays,
                        "Working Days",
                        "Mon - Fri",
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        LucideIcons.clock,
                        "Working Hours",
                        "8:00 AM - 5:00 PM",
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        LucideIcons.users,
                        "Headcount",
                        "3 Positions",
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        LucideIcons.calendarX,
                        "Closing Date",
                        "26 Jul 2026",
                        isUrgent: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                const SizedBox(height: 20),

                // ── ៤. អត្ថបទពិពណ៌នា (ប្រើប្រាស់ Array ពី JSON) ──
                _buildSectionTitle("Job Description"),
                const SizedBox(height: 12),
                // ឧទាហរណ៍ពី Array នៃ JSON
                _buildBulletPoint(
                  "Design, develop, and maintain high-quality software solutions.",
                ),
                _buildBulletPoint(
                  "Collaborate with cross-functional teams to define and ship new features.",
                ),
                const SizedBox(height: 24),

                _buildSectionTitle("Requirements"),
                const SizedBox(height: 12),
                _buildBulletPoint(
                  "Bachelor's degree in Computer Science or related field.",
                ),
                _buildBulletPoint(
                  "3+ years of working experience in mobile app development.",
                ),
                _buildBulletPoint(
                  "Strong knowledge of Flutter framework and Dart language.",
                ),
                const SizedBox(height: 24),

                _buildSectionTitle("Benefits"),
                const SizedBox(height: 12),
                _buildBulletPoint("Competitive salary based on experience."),
                _buildBulletPoint(
                  "Annual performance bonus (13th-month salary).",
                ),
                _buildBulletPoint("Health and accident insurance coverage."),
                const SizedBox(height: 24),

                _buildSectionTitle("Required Skills"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSkillChip("Flutter"),
                    _buildSkillChip("Dart"),
                    _buildSkillChip("RESTful API"),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // ── ៥. Bottom Bar (Status Control សម្រាប់ Employer) ──
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          // ហៅ DELETE API ឬ PATCH Status ទៅបិទ
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Close Job",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // មើលបញ្ជីអ្នកដាក់ពាក្យ
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF4f7df7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "View Applicants",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ── Helper Widgets ──
  // ==========================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Center(
            child: Icon(
              LucideIcons.building,
              size: 32,
              color: Color(0xFF4f7df7),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Senior Flutter Developer", // title ពី JSON
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Active", // status ពី JSON
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // ប្រើ min_salary, max_salary, salary_period និង is_negotiable
        _buildTag(
          LucideIcons.dollarSign,
          "\$1000 - \$2000 / Month (Negotiable)",
          const Color(0xFFE8FDF3),
          const Color(0xFF0F9D58),
        ),
        // ប្រើ employment_type_id
        _buildTag(
          LucideIcons.briefcase,
          "Full-Time",
          const Color(0xFFE8F0FE),
          const Color(0xFF4f7df7),
        ),
        // ប្រើ experience
        _buildTag(
          LucideIcons.graduationCap,
          "3+ Years",
          const Color(0xFFFEF3E8),
          const Color(0xFFE37400),
        ),
        // ប្រើ district_id និង province_id
        _buildTag(
          LucideIcons.mapPin,
          "Phnom Penh",
          Colors.grey.shade100,
          Colors.grey.shade700,
        ),
      ],
    );
  }

  Widget _buildTag(
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isUrgent = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isUrgent ? Colors.red : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(fontSize: 13, color: Color(0xFF4f7df7)),
      ),
      backgroundColor: const Color(0xFFF0F4FF),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
