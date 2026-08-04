import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class ProfileSectionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle; // 🎯 បន្ថែម Subtitle សម្រាប់បង្ហាញព័ត៌មានខ្លីៗ
  final VoidCallback onTap;
  final bool isCompleted;

  const ProfileSectionItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // រាងកោងជាងមុន
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), // ស្រមោលទន់ជាងមុន
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ), // ទីធ្លាធំទូលាយជាងមុន[cite: 9]
            child: Row(
              children: [
                // 🎯 ផ្នែក Icon ខាងឆ្វេង
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primaryLight.withValues(alpha: 0.5)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isCompleted
                        ? AppColors.primary
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),

                // 🎯 ផ្នែក អត្ថបទ (Title & Subtitle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 🎯 ផ្នែក Icon ខាងស្តាំ (Add ឬ Arrow)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.grey.shade50
                        : AppColors.primaryLight,
                    shape: BoxShape.circle, // ប្តូរទៅជារាងរង្វង់ស្អាតជាងមុន
                  ),
                  child: Icon(
                    isCompleted ? Icons.arrow_forward_ios_rounded : Icons.add,
                    size: 15,
                    color: isCompleted
                        ? Colors.grey.shade400
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
