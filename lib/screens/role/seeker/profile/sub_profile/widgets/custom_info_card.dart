import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors import

class CustomInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 🟢 Grab the active theme data
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Dynamic Card BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkCardBorder
              : AppColors.cardBorder, // 🟢 Dynamic Border
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.1 : 0.02,
            ), // 🟢 Adjusted shadow
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ផ្ទៃបង្ហាញអក្សរ
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
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme
                        .textTheme
                        .bodyMedium
                        ?.color, // 🟢 Dynamic Subtitle
                    fontSize: 14,
                  ),
                ),

                // 🎯 ប្រើលក្ខខណ្ឌនៅទីនេះ៖ បង្ហាញ Container នេះទាល់តែ dateText មិនទទេ
                if (dateText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.primaryLight, // 🟢 Dynamic Date BG
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      dateText,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.primaryDark, // 🟢 Dynamic Date Text
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // ផ្ទៃប៊ូតុងសកម្មភាព
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary, // 🟢 Swapped to brand primary
                  size: 22,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error, // 🟢 Swapped to brand error
                  size: 22,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
