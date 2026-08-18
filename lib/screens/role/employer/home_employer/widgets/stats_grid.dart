import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StatItem {
  final String label;
  final String value;
  final String delta;
  final bool up;
  final IconData icon;
  final List<Color> gradient;

  const StatItem({
    required this.label,
    required this.value,
    required this.delta,
    required this.up,
    required this.icon,
    required this.gradient,
  });
}

// Ensure the data list can be passed or dynamically generated to support translations.
// We use a getter method here so GetX (.tr) works efficiently at build time.
List<StatItem> get kStats => [
  StatItem(
    label: "Jobs Posted".tr, // 🟢 Added .tr
    value: "24",
    delta: "+3",
    up: true,
    icon: LucideIcons.briefcase,
    gradient: const [Color(0xFF4F7DF7), Color(0xFF78A8FF)],
  ),
  StatItem(
    label: "Total Applications".tr, // 🟢 Added .tr
    value: "863",
    delta: "+48",
    up: true,
    icon: LucideIcons.users,
    gradient: const [Color(0xFF8B5CF6), Color(0xFFC4B5FD)],
  ),
  StatItem(
    label: "Interviews".tr, // 🟢 Added .tr
    value: "39",
    delta: "+7",
    up: true,
    icon: LucideIcons.checkCircle,
    gradient: const [Color(0xFF22C55E), Color(0xFF86EFAC)],
  ),
  StatItem(
    label: "Hired This Month".tr, // 🟢 Added .tr
    value: "12",
    delta: "+2",
    up: true,
    icon: LucideIcons.trendingUp,
    gradient: const [Color(0xFFF59E0B), Color(0xFFFCD34D)],
  ),
];

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kStats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => _StatCard(stat: kStats[index]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatItem stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stat.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.08, // 🟢 Updated opacity
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: 0.1,
                  ), // 🟢 Updated opacity
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.22,
                        ), // 🟢 Updated opacity
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(stat.icon, size: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      stat.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.8,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(
                          alpha: 0.9,
                        ), // 🟢 Updated opacity
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 12,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 80),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.22,
                    ), // 🟢 Updated opacity
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_outward,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          stat.delta,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      ),
    );
  }
}
