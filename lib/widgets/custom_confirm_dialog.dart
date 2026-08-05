import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color confirmColor;
  final IconData? icon;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.confirmColor = Colors.redAccent,
    this.icon = LucideIcons.trash2,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🎯 Icon ផ្នែកខាងលើ (រចនាជារង្វង់)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: confirmColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: confirmColor, size: 36),
            ),
            const SizedBox(height: 20),

            // 🎯 ចំណងជើង
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 🎯 អត្ថបទពិពណ៌នា
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // 🎯 ប៊ូតុងទាំង ២
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // បិទ Dialog សិន
                      onConfirm(); // ដំណើរការមុខងារលុប
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
