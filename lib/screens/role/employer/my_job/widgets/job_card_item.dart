import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobCardItem extends StatelessWidget {
  final String title;
  final String department;
  final String location;
  final String timeAgo;
  final String status; // ឧ. 'active', 'draft', 'inactive'
  final bool isUrgent;
  final int candidatesCount;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const JobCardItem({
    super.key,
    required this.title,
    required this.department,
    required this.location,
    required this.timeAgo,
    required this.status,
    this.isUrgent = false,
    required this.candidatesCount,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();

    Color badgeColor = Colors.grey.shade100;
    Color badgeTextColor = Colors.grey.shade700;

    if (statusLower == 'active') {
      badgeColor = Colors.green.shade100;
      badgeTextColor = Colors.green.shade700;
    } else if (statusLower == 'inactive') {
      badgeColor = Colors.red.shade100; // ពណ៌ក្រហម/ផ្កាឈូកស្រាល
      badgeTextColor = Colors.red.shade700;
    } else if (statusLower == 'draft') {
      badgeColor = Colors.orange.shade100;
      badgeTextColor = Colors.orange.shade800;
    } else if (statusLower == 'closed') {
      badgeColor = Colors.grey.shade200;
      badgeTextColor = Colors.grey.shade700;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
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
            // ── 1. ផ្នែកខាងលើ (Logo, Title, Status, More Icon) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // រូប Logo ក្រុមហ៊ុន / Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF), // ពណ៌ខៀវស្រាល
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.briefcase,
                    color: Color(0xFF4f7df7),
                  ),
                ),
                const SizedBox(width: 12),

                // ផ្នែកអក្សរ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            department,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          if (isUrgent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "URGENT",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // បន្ទះ Status (ACTIVE / DRAFT)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onMoreTap,
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── 2. ផ្នែកកណ្តាល (ទីតាំង និង ពេលវេលា) ──
            Row(
              children: [
                Icon(LucideIcons.mapPin, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 16),
                Icon(LucideIcons.clock, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF3F4F6)),
            ),

            // ── 3. ផ្នែកខាងក្រោម (Candidates Avatars & Arrow) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 🎯 លក្ខខណ្ឌទី១: បង្ហាញរូប Profile លុះត្រាតែមានបេក្ខជន (candidatesCount > 0)
                    if (candidatesCount > 0) ...[
                      _buildOverlappingAvatars(),
                      const SizedBox(width: 12),
                    ],

                    // 🎯 លក្ខខណ្ឌទី២: ប្តូរពណ៌អក្សរតាមចំនួនបេក្ខជន
                    Text(
                      candidatesCount == 0
                          ? "No candidates yet" // ឬអ្នកអាចដាក់ "0 candidates" ដូចដើមក៏បាន
                          : "$candidatesCount candidates",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: candidatesCount == 0
                            ? Colors
                                  .grey
                                  .shade500 // ពណ៌ប្រផេះពេលគ្មានមនុស្ស
                            : const Color(0xFF4f7df7), // ពណ៌ខៀវពេលមានមនុស្ស
                      ),
                    ),
                  ],
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // មុខងារសម្រាប់គូររូប Avatar ត្រួតលើគ្នា (B, C, D)
  Widget _buildOverlappingAvatars() {
    // ការពារ Error បើសិនជាចំនួន 0 មិនបាច់គូរអ្វីទាំងអស់
    if (candidatesCount == 0) return const SizedBox.shrink();

    // 🎯 លក្ខខណ្ឌទី៣: កំណត់ចំនួនរូបដែលត្រូវបង្ហាញ (អតិបរមាគឺ ៣ រូប)
    final displayCount = candidatesCount > 3 ? 3 : candidatesCount;

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
    ];
    final letters = [
      'A',
      'B',
      'C',
    ]; // អាចប្តូរជាអក្សរទី១នៃឈ្មោះបេក្ខជននៅថ្ងៃក្រោយ

    return SizedBox(
      // គណនាប្រវែង Width សរុបដោយស្វ័យប្រវត្តិ អាស្រ័យលើចំនួនរូបភាព (រូបទី១ 26px, រូបបន្ទាប់ថែម 18px)
      width: 26.0 + ((displayCount - 1) * 18.0),
      height: 26,
      child: Stack(
        children: List.generate(displayCount, (index) {
          return Positioned(
            left: index * 18.0, // រំកិលទៅស្តាំម្តងបន្តិចៗ (Overlap effect)

            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
