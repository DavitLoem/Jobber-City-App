import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobCardItem extends StatelessWidget {
  final String title;
  final String? logoUrl;
  final String department;
  final String location;
  final String timeAgo;
  final String status;
  final bool isUrgent;
  final int candidatesCount;
  final List<String> avatars;
  final VoidCallback onTap;
  final VoidCallback onCandidatesTap;
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
    this.avatars = const [],
    required this.onTap,
    required this.onCandidatesTap,
    required this.onMoreTap,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();

    Color badgeColor = Colors.grey.shade100;
    Color badgeTextColor = Colors.grey.shade700;
    String displayStatus = status
        .toUpperCase(); // 🟢 បន្ថែមអថេរនេះមួយទៀតសម្រាប់ប្តូរអក្សរ

    if (statusLower == 'active') {
      badgeColor = Colors.green.shade50;
      badgeTextColor = Colors.green.shade700;
      displayStatus = 'ACTIVE';
    } else if (statusLower == 'inactive' || statusLower == 'paused') {
      badgeColor = Colors.orange.shade50; // 🟢 ពណ៌ទឹកក្រូច សម្រាប់ Paused
      badgeTextColor = Colors.orange.shade700;
      displayStatus =
          'PAUSED'; // 🟢 បង្ខំឱ្យចេញពាក្យ PAUSED ទោះជា Backend បោះមក inactive ក៏ដោយ
    } else if (statusLower == 'closed') {
      badgeColor = Colors.red.shade50; // 🟢 ពណ៌ក្រហម សម្រាប់ Closed
      badgeTextColor = Colors.red.shade700;
      displayStatus = 'CLOSED';
    } else if (statusLower == 'draft') {
      badgeColor = Colors.grey.shade100; // 🟢 ពណ៌ប្រផេះ សម្រាប់ Draft
      badgeTextColor = Colors.grey.shade700;
      displayStatus = 'DRAFT';
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: logoUrl != null && logoUrl!.isNotEmpty
                        ? Image.network(
                            logoUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            LucideIcons.briefcase,
                            size: 28,
                            color: Colors.grey.shade400,
                          ),
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
                    displayStatus,
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
            // ── 3. ផ្នែកខាងក្រោម (Candidates Avatars & Arrow) ──
            GestureDetector(
              onTap: onCandidatesTap,
              behavior: HitTestBehavior
                  .opaque, // 🟢 សំខាន់បំផុត៖ បង្ខំឱ្យវាចាប់យកការចុចពេញផ្ទៃទាំងមូល មិនឱ្យធ្លាយទៅ InkWell
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                ), // 🟢 ជួយឱ្យផ្ទៃចុចធំជាងមុន ងាយស្រួលចុចលើទូរស័ព្ទ
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (candidatesCount > 0) ...[
                          _buildOverlappingAvatars(),
                          const SizedBox(width: 12),
                        ],

                        Text(
                          candidatesCount == 0
                              ? "No candidates yet"
                              : "$candidatesCount candidate${candidatesCount > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: candidatesCount == 0
                                ? Colors.grey.shade500
                                : const Color(0xFF4f7df7),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // មុខងារសម្រាប់គូររូប Avatar ត្រួតលើគ្នា (B, C, D)
  // 🟢 មុខងារសម្រាប់គូររូប Avatar ត្រួតលើគ្នា
  Widget _buildOverlappingAvatars() {
    if (candidatesCount == 0) return const SizedBox.shrink();

    // បង្ហាញអតិបរមាត្រឹម ៣ រូប
    final displayCount = candidatesCount > 3 ? 3 : candidatesCount;
    final fallbackColors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
    ];

    return SizedBox(
      width: 26.0 + ((displayCount - 1) * 18.0),
      height: 26,
      child: Stack(
        children: List.generate(displayCount, (index) {
          // ឆែកមើលថាតើមាន URL សម្រាប់ Index នេះឬអត់
          final hasImage = index < avatars.length && avatars[index].isNotEmpty;

          return Positioned(
            left: index * 18.0,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: hasImage ? Colors.white : fallbackColors[index],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(avatars[index]),
                        fit: BoxFit.cover,
                      )
                    : null, // បើគ្មានរូប វានឹងប្រើពណ៌ខាងលើ
              ),
              child: !hasImage
                  ? const Center(
                      child: Icon(
                        LucideIcons.user,
                        size: 14,
                        color: Colors.white,
                      ), // បើគ្មានរូប ប្រើ Icon ជំនួសអក្សរ
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }
}
