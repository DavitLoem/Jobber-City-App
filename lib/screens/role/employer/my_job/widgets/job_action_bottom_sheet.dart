import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JobActionBottomSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onPause;
  final VoidCallback onDuplicate;
  final VoidCallback onCloseJob;
  final VoidCallback onDelete;

  final String pauseLabel;
  final IconData pauseIcon;

  const JobActionBottomSheet({
    super.key,
    required this.onEdit,
    required this.onShare,
    required this.onPause,
    required this.onDuplicate,
    required this.onCloseJob,
    required this.onDelete,
    this.pauseLabel = "Pause Job",
    this.pauseIcon = LucideIcons.pause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag Handle (បន្ទាត់ខ្លីកណ្តាលខាងលើ) ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── ចំណងជើង ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Job Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── បញ្ជី Actions ──
          _buildActionItem(
            icon: LucideIcons.pencil,
            label: "Edit Job",
            onTap: onEdit,
          ),
          _buildActionItem(
            icon: LucideIcons.upload, // ឬប្រើ share ក៏បាន
            label: "Share",
            onTap: onShare,
          ),
          _buildActionItem(icon: pauseIcon, label: pauseLabel, onTap: onPause),
          _buildActionItem(
            icon: LucideIcons.copy,
            label: "Duplicate Job",
            onTap: onDuplicate,
          ),
          _buildActionItem(
            icon: LucideIcons.archive, // ប្រើ Icon ប្រអប់សម្រាប់ Close
            label: "Close Job",
            onTap: onCloseJob,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(color: Color(0xFFF3F4F6), height: 1),
          ),

          // ── ប៊ូតុង Delete (ពណ៌ក្រហម) ──
          _buildActionItem(
            icon: LucideIcons.trash2,
            label: "Delete Job",
            isDestructive: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }

  // មុខងារជំនួយសម្រាប់គូរប៊ូតុងនីមួយៗ
  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false, // កំណត់ថាជាប៊ូតុងលុបឬអត់
  }) {
    final color = isDestructive ? Colors.red : Colors.black87;
    final bgColor = isDestructive ? Colors.red.shade50 : Colors.grey.shade50;
    final iconColor = isDestructive ? Colors.red : Colors.grey.shade700;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // រូប Icon ដែលមានផ្ទៃខាងក្រោយរាងមូល
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            // អក្សរ Label
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
