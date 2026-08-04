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

    // 🎯 ប្រើ RxList<String> ដើម្បីផ្ទុកតែ ID បានហើយ ងាយស្រួលឆែកមើលសញ្ញាគ្រីស
    RxList<String> tempSelectedIds = initialSelectedIds.toList().obs;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Search skills...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
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
                        title: Text(getName(item)),
                        value: isSelected,
                        activeColor: AppColors.primary,
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
                      // 🎯 បំប្លែង ID ត្រឡប់ទៅជា Object វិញ មុនបញ្ជូនទៅ Step 3
                      final selectedItems = items
                          .where((e) => tempSelectedIds.contains(getId(e)))
                          .toList();
                      onApply(selectedItems);
                      Get.back();
                    },
                    child: Obx(
                      () => Text(
                        "Apply (${tempSelectedIds.length} selected)",
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
