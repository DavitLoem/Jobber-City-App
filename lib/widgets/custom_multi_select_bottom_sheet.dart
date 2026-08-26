import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomMultiSelectBottomSheet {
  static void show<T>({
    required String title,
    required List<T> items,
    required List<String> initialSelectedIds,
    required String Function(T) getName,
    required String Function(T) getId,
    required void Function(List<T>) onApply,
  }) {
    TextEditingController searchCtrl = TextEditingController();
    RxList<T> filteredItems = items.toList().obs;
    final isDark = Get.isDarkMode; // 🟢 Static Theme Context Check

    RxList<String> tempSelectedIds = initialSelectedIds.toList().obs;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackground
              : Colors.white, // 🟢 Dynamic BottomSheet BG
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.tr, // 🟢 Translation fallback
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black87, // 🟢 Dynamic Text
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.darkIconSecondary : Colors.grey,
                  ), // 🟢 Dynamic Icon
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchCtrl,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ), // 🟢 Dynamic Input Text
              decoration: InputDecoration(
                hintText: "Search...".tr, // 🟢 Generic hint mapping
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextHint : Colors.grey,
                ), // 🟢 Dynamic Hint
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
                    final itemId = getId(item);

                    return Obx(() {
                      final isSelected = tempSelectedIds.contains(itemId);
                      return CheckboxListTile(
                        title: Text(
                          getName(item).tr, // Optional tr depending on use case
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ), // 🟢 Dynamic List Text
                        ),
                        value: isSelected,
                        activeColor: isDark
                            ? Colors.blueAccent
                            : AppColors.primary, // 🟢 Dynamic Active Checkbox
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (bool? checked) {
                          if (checked == true) {
                            tempSelectedIds.add(itemId);
                          } else {
                            tempSelectedIds.remove(itemId);
                          }
                        },
                      );
                    });
                  },
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final selectedItems = items
                          .where((e) => tempSelectedIds.contains(getId(e)))
                          .toList();
                      onApply(selectedItems);
                      Get.back();
                    },
                    child: Obx(
                      () => Text(
                        "Apply (@count selected)".trParams({
                          'count': tempSelectedIds.length.toString(),
                        }), // 🟢 Added .trParams
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
