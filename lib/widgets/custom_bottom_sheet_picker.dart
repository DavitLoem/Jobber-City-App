import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomBottomSheetPicker {
  static void show<T>({
    required String title,
    required List<T> items,
    required String Function(T) getName,
    required void Function(T) onSelected,
  }) {
    TextEditingController searchCtrl = TextEditingController();
    RxList<T> filteredItems = items.toList().obs;

    final theme = Get.theme; // 🟢 Get active theme context
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.65,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // 🟢 Dynamic Modal BG
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: searchCtrl,
              style: TextStyle(
                color: isDark ? AppColors.darkInputText : AppColors.inputText,
              ),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputBackground
                    : Colors.grey.shade100, // 🟢 Dynamic Input BG
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                filteredItems.value = items
                    .where(
                      (item) => getName(
                        item,
                      ).toLowerCase().contains(value.toLowerCase()),
                    )
                    .toList();
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(
                        getName(item),
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                        ), // 🟢 Dynamic List Text
                      ),
                      onTap: () {
                        onSelected(item);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
