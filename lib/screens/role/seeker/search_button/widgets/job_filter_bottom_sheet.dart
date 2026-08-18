import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../search_button_controller.dart';

class JobFilterBottomSheet extends StatefulWidget {
  const JobFilterBottomSheet({super.key});

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  final SearchButtonViewController searchCtrl =
      Get.find<SearchButtonViewController>();
  final CategoryController categoryCtrl = Get.find<CategoryController>();
  final LocationController locationCtrl = Get.find<LocationController>();
  final MasterDataController masterDataCtrl = Get.find<MasterDataController>();

  String? _selectedCategoryId;
  String? _selectedIndustryId;
  double? _minSalary;
  double? _maxSalary;
  String? _selectedJobLevelId;
  String? _selectedEmploymentTypeId;
  String? _selectedProvinceId;

  List<Map<String, String>> industries = [];
  List<Map<String, String>> jobLevels = [];
  List<Map<String, String>> empTypes = [];
  bool isMasterDataLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = searchCtrl.selectedCategoryId.value;
    _selectedIndustryId = searchCtrl.selectedIndustryId.value;
    _minSalary = searchCtrl.minSalary.value;
    _maxSalary = searchCtrl.maxSalary.value;
    _selectedJobLevelId = searchCtrl.selectedJobLevelId.value;
    _selectedEmploymentTypeId = searchCtrl.selectedEmploymentTypeId.value;
    _selectedProvinceId = searchCtrl.selectedProvinceId.value;

    _loadMasterData();
  }

  Future<void> _loadMasterData() async {
    final indRes = await masterDataCtrl.getMasterData(endpoint: 'industries');
    final jlRes = await masterDataCtrl.getMasterData(endpoint: 'job-levels');
    final etRes = await masterDataCtrl.getMasterData(
      endpoint: 'employment-types',
    );

    if (mounted) {
      setState(() {
        industries = indRes
            .map((e) => {'id': e.id.toString(), 'name': e.name.toString()})
            .toList();
        jobLevels = jlRes
            .map((e) => {'id': e.id.toString(), 'name': e.name.toString()})
            .toList();
        empTypes = etRes
            .map((e) => {'id': e.id.toString(), 'name': e.name.toString()})
            .toList();
        isMasterDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: Get.height * 0.88,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(theme, isDark),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                _buildSectionTitle('Category'.tr, theme), // 🟢 Added .tr
                Obx(() {
                  if (categoryCtrl.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = categoryCtrl.categories
                      .map(
                        (c) => {
                          'id': c.id.toString(),
                          'name': c.name.toString(),
                        },
                      )
                      .toList();
                  return _buildSelector(
                    title:
                        'Category', // Translation is handled inside the method
                    selectedId: _selectedCategoryId,
                    items: items,
                    theme: theme,
                    isDark: isDark,
                    onSelected: (val) =>
                        setState(() => _selectedCategoryId = val),
                  );
                }),
                const SizedBox(height: 20),

                _buildSectionTitle(
                  'Location (Province)'.tr,
                  theme,
                ), // 🟢 Added .tr
                Obx(() {
                  if (locationCtrl.isLoadingProvinces.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = locationCtrl.provinces
                      .map(
                        (p) => {
                          'id': p.id.toString(),
                          'name': p.nameEn.toString(),
                        },
                      )
                      .toList();
                  return _buildSelector(
                    title: 'Location',
                    selectedId: _selectedProvinceId,
                    items: items,
                    theme: theme,
                    isDark: isDark,
                    onSelected: (val) =>
                        setState(() => _selectedProvinceId = val),
                  );
                }),
                const SizedBox(height: 20),

                _buildSectionTitle(
                  'Salary Range (Monthly)'.tr,
                  theme,
                ), // 🟢 Added .tr
                _buildSalaryRangeSlider(isDark),
                const SizedBox(height: 24),

                _buildSectionTitle('Employment Type'.tr, theme), // 🟢 Added .tr
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildChips(
                        _selectedEmploymentTypeId,
                        empTypes,
                        theme,
                        isDark,
                        (val) =>
                            setState(() => _selectedEmploymentTypeId = val),
                      ),
                const SizedBox(height: 32),

                Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.cardBorder,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Advanced Filters'.tr, // 🟢 Added .tr
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('Industry'.tr, theme), // 🟢 Added .tr
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSelector(
                        title: 'Industry',
                        selectedId: _selectedIndustryId,
                        items: industries,
                        theme: theme,
                        isDark: isDark,
                        onSelected: (val) =>
                            setState(() => _selectedIndustryId = val),
                      ),
                const SizedBox(height: 20),

                _buildSectionTitle('Job Level'.tr, theme), // 🟢 Added .tr
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildChips(
                        _selectedJobLevelId,
                        jobLevels,
                        theme,
                        isDark,
                        (val) => setState(() => _selectedJobLevelId = val),
                      ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildActionButtons(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.cardBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Jobs'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.lightSurfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title, // Translated in the build method
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildSelector({
    required String title,
    required String? selectedId,
    required List<Map<String, String>> items,
    required ThemeData theme,
    required bool isDark,
    required Function(String?) onSelected,
  }) {
    String displayValue = 'Select option'.tr; // 🟢 Added .tr
    if (selectedId != null) {
      final selectedItem = items.firstWhereOrNull(
        (item) => item['id'] == selectedId,
      );
      if (selectedItem != null) {
        displayValue = selectedItem['name']!;
      }
    }

    return GestureDetector(
      onTap: () {
        if (items.isNotEmpty) {
          _showSelectionModal(
            title,
            selectedId,
            items,
            theme,
            isDark,
            onSelected,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayValue,
                style: TextStyle(
                  color: selectedId == null
                      ? (isDark ? AppColors.darkTextHint : AppColors.textHint)
                      : theme.textTheme.bodyLarge?.color,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectionModal(
    String title,
    String? selectedId,
    List<Map<String, String>> items,
    ThemeData theme,
    bool isDark,
    Function(String?) onSelected,
  ) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.cardBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select @title'.trParams({
                      'title': title.tr,
                    }), // 🟢 Dynamic parameter translation
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item['id'] == selectedId;

                  return ListTile(
                    title: Text(
                      item['name']!,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      onSelected(item['id']);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSalaryRangeSlider(bool isDark) {
    double min = _minSalary ?? 100;
    double max = _maxSalary ?? 1500;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${min.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              max >= 3000 ? '\$3000+' : '\$${max.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(min, max),
          min: 100,
          max: 3000,
          divisions: 29,
          activeColor: AppColors.primary,
          inactiveColor: isDark
              ? AppColors.primary.withValues(alpha: 0.2) // 🟢 Updated opacity
              : AppColors.primaryLight,
          onChanged: (RangeValues values) {
            setState(() {
              _minSalary = values.start;
              _maxSalary = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildChips(
    String? selectedValue,
    List<Map<String, String>> items,
    ThemeData theme,
    bool isDark,
    Function(String?) onChanged,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selectedValue == item['id'];
        return ChoiceChip(
          label: Text(item['name']!),
          selected: isSelected,
          onSelected: (selected) => onChanged(selected ? item['id'] : null),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05, // 🟢 Updated opacity
            ),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                searchCtrl.resetFilters();
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Reset'.tr, // 🟢 Added .tr
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                searchCtrl.applyFilters(
                  categoryId: _selectedCategoryId,
                  industryId: _selectedIndustryId,
                  minSal: _minSalary,
                  maxSal: _maxSalary,
                  jobLevelId: _selectedJobLevelId,
                  empTypeId: _selectedEmploymentTypeId,
                  provId: _selectedProvinceId,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Apply Filter'.tr, // 🟢 Added .tr
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
