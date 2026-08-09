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

  // 🎯 ទាញយក Controllers ដែលបាន Put នៅក្នុង Search Controller
  final CategoryController categoryCtrl = Get.find<CategoryController>();
  final LocationController locationCtrl = Get.find<LocationController>();
  final MasterDataController masterDataCtrl = Get.find<MasterDataController>();

  // ── អថេរផ្ទុកទិន្នន័យបណ្ដោះអាសន្ន ──
  String? _selectedCategoryId;
  String? _selectedIndustryId;
  double? _minSalary;
  double? _maxSalary;
  String? _selectedJobLevelId;
  String? _selectedEmploymentTypeId;
  String? _selectedProvinceId;

  // ── អថេរសម្រាប់ផ្ទុកទិន្នន័យពី MasterDataController ──
  List<Map<String, String>> industries = [];
  List<Map<String, String>> jobLevels = [];
  List<Map<String, String>> empTypes = [];
  bool isMasterDataLoading = true;

  @override
  void initState() {
    super.initState();
    // ១. ទាញយកតម្លៃចាស់ដែលគាត់បានរើសមកបង្ហាញវិញ (បើមាន)
    _selectedCategoryId = searchCtrl.selectedCategoryId.value;
    _selectedIndustryId = searchCtrl.selectedIndustryId.value;
    _minSalary = searchCtrl.minSalary.value;
    _maxSalary = searchCtrl.maxSalary.value;
    _selectedJobLevelId = searchCtrl.selectedJobLevelId.value;
    _selectedEmploymentTypeId = searchCtrl.selectedEmploymentTypeId.value;
    _selectedProvinceId = searchCtrl.selectedProvinceId.value;

    // ២. ហៅទិន្នន័យពី Master Data API
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
        // 🎯 បំប្លែង MasterDataModel ទៅជា Map ដើម្បីងាយស្រួលគូរ UI
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
    return Container(
      height: Get.height * 0.88, // តម្លើងកម្ពស់បន្តិច
      decoration: const BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                _buildSectionTitle('Category'),
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
                  // 🎯 ហៅ _buildSelector ជំនួសវិញ
                  return _buildSelector(
                    title: 'Category',
                    selectedId: _selectedCategoryId,
                    items: items,
                    onSelected: (val) =>
                        setState(() => _selectedCategoryId = val),
                  );
                }),
                const SizedBox(height: 20),

                _buildSectionTitle('Location (Province)'),
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
                    onSelected: (val) =>
                        setState(() => _selectedProvinceId = val),
                  );
                }),
                const SizedBox(height: 20),

                _buildSectionTitle('Salary Range (Monthly)'),
                _buildSalaryRangeSlider(),
                const SizedBox(height: 24),

                _buildSectionTitle('Employment Type'),
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildChips(
                        _selectedEmploymentTypeId,
                        empTypes,
                        (val) =>
                            setState(() => _selectedEmploymentTypeId = val),
                      ),
                const SizedBox(height: 32),

                // ── ផ្នែក Advanced Filters ──
                const Divider(color: AppColors.cardBorder),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Advanced Filters',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('Industry'),
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSelector(
                        title: 'Industry',
                        selectedId: _selectedIndustryId,
                        items: industries,
                        onSelected: (val) =>
                            setState(() => _selectedIndustryId = val),
                      ),
                const SizedBox(height: 20),

                _buildSectionTitle('Job Level'),
                isMasterDataLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildChips(
                        _selectedJobLevelId,
                        jobLevels,
                        (val) => setState(() => _selectedJobLevelId = val),
                      ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // ─── UI Components ───

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Jobs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // 🎯 ១. ប្រអប់សម្រាប់ចុចឱ្យលោតផ្ទាំងរើស (ជំនួស Dropdown ចាស់)
  Widget _buildSelector({
    required String title,
    required String? selectedId,
    required List<Map<String, String>> items,
    required Function(String?) onSelected,
  }) {
    // ស្វែងរកឈ្មោះដើម្បីបង្ហាញ បើគាត់បានរើសរួច
    String displayValue = 'Select option';
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
        // កុំឲ្យចុចលោតផ្ទាំង បើទិន្នន័យមិនទាន់ Load ចប់
        if (items.isNotEmpty) {
          _showSelectionModal(title, selectedId, items, onSelected);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayValue,
                style: TextStyle(
                  color: selectedId == null
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 ២. ផ្ទាំងបញ្ជីដែលលោតឡើងមកពេលចុចរើស
  void _showSelectionModal(
    String title,
    String? selectedId,
    List<Map<String, String>> items,
    Function(String?) onSelected,
  ) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6, // យកកម្ពស់ត្រឹម 60%
        decoration: const BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // ── Header របស់ Modal ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select $title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // ── បញ្ជីទិន្នន័យ (ListView) ──
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
                            : AppColors.textPrimary,
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
                      Get.back(); // រើសរួច បិទផ្ទាំងនេះភ្លាម
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

  Widget _buildSalaryRangeSlider() {
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
          inactiveColor: AppColors.primaryLight,
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
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                searchCtrl.resetFilters(); // 🎯 ហៅមុខងារ Reset ក្នុង Controller
                Get.back(); // បិទ BottomSheet
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // 🎯 បោះតម្លៃដែលបានរើសទៅឱ្យ Controller ដើម្បីធ្វើការ Search
                searchCtrl.applyFilters(
                  categoryId: _selectedCategoryId,
                  industryId: _selectedIndustryId,
                  minSal: _minSalary,
                  maxSal: _maxSalary,
                  jobLevelId: _selectedJobLevelId,
                  empTypeId: _selectedEmploymentTypeId,
                  provId: _selectedProvinceId,
                );
                Get.back(); // បិទ BottomSheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
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
