import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(16), //[cite: 9]
      decoration: BoxDecoration(
        color: Colors.white, //[cite: 9]
        borderRadius: BorderRadius.circular(16), //[cite: 9]
        border: Border.all(color: Colors.grey.shade200), //[cite: 9]
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), //[cite: 9]
            blurRadius: 8, //[cite: 9]
            offset: const Offset(0, 2), //[cite: 9]
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //[cite: 9]
        children: [
          // ផ្ទៃបង្ហាញអក្សរ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //[cite: 9]
              children: [
                Text(
                  title, //[cite: 9]
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, //[cite: 9]
                    fontSize: 16, //[cite: 9]
                    color: Colors.black87, //[cite: 9]
                  ),
                ),
                const SizedBox(height: 6), //[cite: 9]
                Text(
                  subtitle, //[cite: 9]
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ), //[cite: 9]
                ),

                // 🎯 ប្រើលក្ខខណ្ឌនៅទីនេះ៖ បង្ហាញ Container នេះទាល់តែ dateText មិនទទេ
                if (dateText.isNotEmpty) ...[
                  const SizedBox(
                    height: 6,
                  ), // រំកិល SizedBox មកក្នុងនេះ ដើម្បីកុំឱ្យចន្លោះធំពេកពេលគ្មាន date
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, //[cite: 9]
                      vertical: 4, //[cite: 9]
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50, //[cite: 9]
                      borderRadius: BorderRadius.circular(6), //[cite: 9]
                    ),
                    child: Text(
                      dateText, //[cite: 9]
                      style: TextStyle(
                        color: Colors.blue.shade700, //[cite: 9]
                        fontSize: 12, //[cite: 9]
                        fontWeight: FontWeight.w600, //[cite: 9]
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
                  Icons.edit_outlined, //[cite: 9]
                  color: Colors.blueAccent, //[cite: 9]
                  size: 22, //[cite: 9]
                ),
                constraints: const BoxConstraints(), //[cite: 9]
                padding: const EdgeInsets.all(8), //[cite: 9]
                onPressed: onEdit, //[cite: 9]
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline, //[cite: 9]
                  color: Colors.redAccent, //[cite: 9]
                  size: 22, //[cite: 9]
                ),
                constraints: const BoxConstraints(), //[cite: 9]
                padding: const EdgeInsets.all(8), //[cite: 9]
                onPressed: onDelete, //[cite: 9]
              ),
            ],
          ),
        ],
      ),
    );
  }
}
