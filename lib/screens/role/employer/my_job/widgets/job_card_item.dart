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
  });

  @override
  Widget build(BuildContext context) {
    // កំណត់ពណ៌ Badge ទៅតាម Status
    final isDraft = status.toLowerCase() == 'draft';
    final badgeColor = isDraft ? Colors.orange.shade100 : Colors.green.shade100;
    final badgeTextColor = isDraft
        ? Colors.orange.shade800
        : Colors.green.shade700;

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
                const Icon(Icons.more_vert, color: Colors.grey, size: 20),
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
                    _buildOverlappingAvatars(), // ហៅមុខងារគូររូប Avatar ត្រួតគ្នា
                    const SizedBox(width: 12),
                    Text(
                      "$candidatesCount candidates",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4f7df7),
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
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
    ];
    final letters = ['B', 'C', 'D'];

    return SizedBox(
      width: 70, // កំណត់ប្រវែងសរុប (កុំឱ្យវាហៀរ)
      height: 26,
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            left: index * 18.0, // រំកិលទៅស្តាំម្តងបន្តិចៗ (Overlap effect)
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ), // គែមសកាត់គ្នា
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
