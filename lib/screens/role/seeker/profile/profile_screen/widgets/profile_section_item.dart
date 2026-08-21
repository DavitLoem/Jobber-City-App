import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class ProfileSectionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isCompleted;

  // 🎯 បន្ថែម Parameter ថ្មីសម្រាប់សម្គាល់ថាជា Resume
  final bool isResume;

  const ProfileSectionItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isCompleted = false,
    this.isResume = false, // លំនាំដើម false
  });

  @override
  Widget build(BuildContext context) {
    // 🎯 កំណត់ Icon ខាងស្តាំតាមលក្ខខណ្ឌ
    IconData rightIcon;
    Color rightIconColor;
    Color rightBgColor;

    if (!isCompleted) {
      // ករណីមិនទាន់មានទិន្នន័យ (ចេញសញ្ញាបូកពណ៌ខៀវ)
      rightIcon = Icons.add;
      rightIconColor = AppColors.primary;
      rightBgColor = AppColors.primaryLight;
    } else if (isResume) {
      // ករណីមានទិន្នន័យ ហើយជា Resume (ចេញសញ្ញាគ្រឹសពណ៌បៃតង)
      rightIcon = Icons.check_circle;
      rightIconColor = Colors.green;
      rightBgColor = Colors.green.shade50;
    } else {
      // ករណីមានទិន្នន័យ ជា List ធម្មតា (ចេញសញ្ញាព្រួញពណ៌ប្រផេះ)
      rightIcon = Icons.arrow_forward_ios_rounded;
      rightIconColor = Colors.grey.shade400;
      rightBgColor = Colors.grey.shade50;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 🎯 ផ្នែក Icon ខាងឆ្វេង (ប្តូរពណ៌តាម isCompleted)
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

                // 🎯 ផ្នែក អត្ថបទ (Title)
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

                // 🎯 ផ្នែក Icon ខាងស្តាំ (ប្រើអថេរដែលកំណត់ខាងលើ)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: rightBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(rightIcon, size: 15, color: rightIconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
