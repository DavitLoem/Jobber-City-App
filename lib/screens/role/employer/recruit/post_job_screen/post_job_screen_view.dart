import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:jobber_city/core/api/services/role/employer/job_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/api/services/role/employer/master_data_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jobber_city/core/api/services/role/seeker/district_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/location_services.dart';
import 'package:jobber_city/models/role/employer/job_post_model.dart';
import 'package:jobber_city/models/role/employer/master_data_item.dart';
import 'package:jobber_city/models/role/seeker/location_model.dart';
import 'package:jobber_city/models/role/seeker/district_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

part 'post_job_screen_binding.dart';
part 'post_job_screen_controller.dart';

// Color mapping to match the new UI snippets with your project
const _outlineLight = Color(0xFFE2E8F0);
const _onSurfaceMuted = Color(0xFF64748B);
const _onSurfaceSecondary = Color(0xFF475569);
const _surfaceVariantLight = Color(0xFFF1F5F9);
const _primaryContainer = Color(0xFFEEF2FF);
const _backgroundLight = Color(0xFFF8FAFC);

class PostJobScreenView extends GetView<PostJobScreenViewController> {
  const PostJobScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: _backgroundLight,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ArrowKeyBack(),
        ),
        title: const Text(
          "Post a Job",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withAlpha(20),
        shape: const Border(bottom: BorderSide(color: _outlineLight, width: 1)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {}, // Handle Save Draft if needed
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Save Draft',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return Column(
            children: [
              // 1. Stepper Widget
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: StepperWidget(currentStep: controller.currentStep.value),
              ),

              // 2. Step Content
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStepContainer(
                      isTablet,
                      Step1BasicInfoWidget(controller: controller),
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step2SalaryWidget(controller: controller),
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step3DetailsWidget(controller: controller),
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step4ScheduleWidget(controller: controller),
                    ),
                  ],
                ),
              ),

              // 3. Sticky NavBar Widget
              // 3. Sticky NavBar Widget
              StickyNavBarWidget(
                currentStep: controller.currentStep.value,
                isPosting: controller.isLoading.value,
                onPrevious: controller.currentStep.value > 0
                    ? () => controller
                          .previousStep() // Uses your controller's logic!
                    : null,
                onNext: () => controller
                    .nextStep(), // Uses your controller's validation and submitJob!
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContainer(bool isTablet, Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 16,
        vertical: 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 600 : double.infinity,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==========================================
// STEP 1: BASIC INFO
// ==========================================
class Step1BasicInfoWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step1BasicInfoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Basic Information',
          'Tell us about the role and where it\'s based',
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Company & Position',
          icon: Icons.business_center_outlined,
          children: [
            _buildLogoSection(), // Automatically displays the caught logo!
            const SizedBox(height: 16),
            FormFieldWrapper(
              label: 'Job Title',
              required: true,
              child: TextFormField(
                controller: controller.titleCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: _inputDecoration(
                  hint: 'e.g. Senior Product Designer',
                  icon: Icons.work_outline_rounded,
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Location',
          icon: Icons.location_on_outlined,
          children: [
            FormFieldWrapper(
              label: 'Province / State',
              required: true,
              child: CitySelectField<LocationModel>(
                controller: controller.provinceCtrl,
                fetchOptions: () => LocationServices().getLocation(),
                labelOf: (loc) => loc.nameEn,
                hintText: "Select province",
                sheetTitle: "Select Province",
                searchHint: "Search province...",
                prefixIcon: Icons.map_outlined,
                onSelected: (loc) {
                  controller.provinceId.value = loc.id;
                  controller.districtCtrl.clear();
                  controller.districtId.value = '';
                },
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => FormFieldWrapper(
                label: 'District / City',
                required: true,
                child: CitySelectField<DistrictModel>(
                  controller: controller.districtCtrl,
                  fetchOptions: controller.provinceId.value.isEmpty
                      ? () async => []
                      : () => DistrictServices().getDistricts(
                          controller.provinceId.value,
                        ),
                  labelOf: (dist) => dist.nameEn,
                  hintText: controller.provinceId.value.isEmpty
                      ? "Select province first"
                      : "Select district",
                  sheetTitle: "Select District",
                  searchHint: "Search district...",
                  prefixIcon: Icons.location_city_outlined,
                  enabled: controller.provinceId.value.isNotEmpty,
                  onSelected: (dist) {
                    controller.districtId.value = dist.id;
                  },
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Job Classification',
          icon: Icons.category_outlined,
          children: [
            FormFieldWrapper(
              label: 'Job Category',
              required: true,
              child: CitySelectField<MasterDataItem>(
                controller: controller.categoryNameCtrl,
                fetchOptions: controller.fetchCategories,
                labelOf: (item) => item.name,
                hintText: "Select category",
                prefixIcon: Icons.category_outlined,
                sheetTitle: "Select Category",
                searchHint: "Search category...",
                onSelected: (item) => controller.categoryId.value = item.id,
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Job Level',
              required: true,
              child: CitySelectField<MasterDataItem>(
                controller: controller.jobLevelNameCtrl,
                fetchOptions: controller.fetchJobLevels,
                labelOf: (item) => item.name,
                hintText: "Select level",
                prefixIcon: Icons.layers_outlined,
                sheetTitle: "Select Job Level",
                searchHint: "Search level...",
                onSelected: (item) => controller.jobLevelId.value = item.id,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Employment Type',
                    required: true,
                    child: CitySelectField<MasterDataItem>(
                      controller: controller.employmentTypeNameCtrl,
                      fetchOptions: controller.fetchEmploymentTypes,
                      labelOf: (item) => item.name,
                      hintText: "Type",
                      prefixIcon: Icons.work_history_outlined,
                      sheetTitle: "Select Employment Type",
                      searchHint: "Search...",
                      onSelected: (item) =>
                          controller.employmentTypeId.value = item.id,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Work Type',
                    required: true,
                    child: CitySelectField<MasterDataItem>(
                      controller: controller.workTypeNameCtrl,
                      fetchOptions: controller.fetchWorkTypes,
                      labelOf: (item) => item.name,
                      hintText: "Mode",
                      prefixIcon: Icons.home_work_outlined,
                      sheetTitle: "Select Work Type",
                      searchHint: "Search...",
                      onSelected: (item) =>
                          controller.workTypeId.value = item.id,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // -----------------------------------------------------
  // Smart Logo Section (Catches URL from Company Profile)
  // -----------------------------------------------------
  Widget _buildLogoSection() {
    return FormFieldWrapper(
      label: 'Company Logo',
      child: Obx(() {
        final hasLogo = controller.companyLogoUrl.value.isNotEmpty;

        return InkWell(
          onTap: () {
            Get.snackbar("Upload", "Wire this to your image picker.");
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _outlineLight, width: 1.5),
            ),
            child: Row(
              children: [
                // Display Fetched Logo OR Placeholder Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: hasLogo ? Colors.white : _primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: hasLogo ? Border.all(color: _outlineLight) : null,
                    image: hasLogo
                        ? DecorationImage(
                            image: NetworkImage(
                              controller.companyLogoUrl.value,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasLogo
                      ? const Icon(
                          Icons.business_rounded,
                          color: AppColors.primary,
                          size: 24,
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Dynamic Text based on status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasLogo
                            ? 'Company Logo Applied'
                            : 'Upload Company Logo',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasLogo
                            ? 'Fetched directly from your profile'
                            : 'Tap to browse (PNG, JPG up to 5MB)',
                        style: const TextStyle(
                          fontSize: 11,
                          color: _onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Icon or Button
                if (hasLogo)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 22,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _outlineLight),
                    ),
                    child: const Text(
                      'Browse',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ==========================================
// STEP 2: SALARY & REQUIREMENTS
// ==========================================
class Step2SalaryWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step2SalaryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Salary & Requirements',
          'Define compensation and candidate requirements',
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Compensation',
          icon: Icons.attach_money_rounded,
          children: [
            FormFieldWrapper(
              label: 'Salary Period',
              child: Obx(
                () => Row(
                  children: controller.salaryPeriodOptions.map((p) {
                    final isSelected = controller.salaryPeriod.value == p;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.salaryPeriod.value = p,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            right: p != controller.salaryPeriodOptions.last
                                ? 8
                                : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : _surfaceVariantLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : _outlineLight,
                            ),
                          ),
                          child: Text(
                            p,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : _onSurfaceSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Minimum Salary',
                    required: true,
                    child: TextFormField(
                      controller: controller.minSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(hint: '500', prefix: '\$ '),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Maximum Salary',
                    required: true,
                    child: TextFormField(
                      controller: controller.maxSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(hint: '1000', prefix: '\$ '),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: controller.isNegotiable.value
                      ? _primaryContainer
                      : _surfaceVariantLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isNegotiable.value
                        ? _primaryContainer
                        : _outlineLight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      size: 18,
                      color: controller.isNegotiable.value
                          ? AppColors.primary
                          : _onSurfaceMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Negotiable Salary',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.isNegotiable.value
                                  ? AppColors.primary
                                  : const Color(0xFF374151),
                            ),
                          ),
                          const Text(
                            'Candidates can negotiate final offer',
                            style: TextStyle(
                              fontSize: 11,
                              color: _onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isNegotiable.value,
                      onChanged: (v) => controller.isNegotiable.value = v,
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Requirements',
          icon: Icons.school_outlined,
          children: [
            FormFieldWrapper(
              label: 'Number of Vacancies',
              required: true,
              child: TextFormField(
                controller: controller.headCountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 14),
                decoration: _inputDecoration(
                  hint: 'e.g. 3',
                  icon: Icons.people_outline_rounded,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Experience Required',
              required: true,
              child: StyledDropdown(
                value: controller.experienceCtrl.text.isEmpty
                    ? null
                    : controller.experienceCtrl.text,
                items: controller.experienceOptions.map((e) => e.name).toList(),
                hint: 'Select experience level',
                prefixIcon: Icons.timeline_outlined,
                onChanged: (v) => controller.experienceCtrl.text = v ?? '',
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Education Level',
              required: true,
              child: CitySelectField<MasterDataItem>(
                controller: controller.educationLevelNameCtrl,
                fetchOptions: controller.fetchEducationLevels,
                labelOf: (item) => item.name,
                hintText: "Select education",
                prefixIcon: Icons.school_outlined,
                sheetTitle: "Select Education Level",
                searchHint: "Search education...",
                onSelected: (item) =>
                    controller.educationLevelId.value = item.id,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// STEP 3: DETAILS
// ==========================================
// ==========================================
// STEP 3: DETAILS
// ==========================================
class Step3DetailsWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step3DetailsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Job Details',
          'Describe the role, requirements, and what you offer',
        ),
        const SizedBox(height: 16),

        // 1. Job Description & About
        StepSectionCard(
          title: 'Job Description',
          icon: Icons.description_outlined,
          children: [
            FormFieldWrapper(
              label: 'Job Description',
              required: true,
              child: TextFormField(
                controller: controller.descCtrl,
                maxLines: 5,
                style: const TextStyle(fontSize: 14, height: 1.5),
                decoration: _inputDecoration(
                  hint: 'Describe the role, responsibilities, and tasks...',
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Minimum Qualifications',
              required: true,
              child: TextFormField(
                controller: controller.reqCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, height: 1.5),
                decoration: _inputDecoration(
                  hint: 'List required education, skills, and experience...',
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'About the Company',
              child: TextFormField(
                controller: controller.aboutCompanyCtrl,
                maxLines: 3,
                style: const TextStyle(fontSize: 14, height: 1.5),
                decoration: _inputDecoration(
                  hint: 'Share your company culture, mission, and values...',
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
          ],
        ),

        // 2. Benefits & Perks
        StepSectionCard(
          title: 'Benefits & Perks',
          icon: Icons.card_giftcard_outlined,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Add Benefits',
                    child: TextFormField(
                      controller: controller.benefitInputCtrl,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'e.g. Health Insurance',
                        icon: Icons.add_circle_outline_rounded,
                      ),
                      onFieldSubmitted: (_) => controller.addBenefit(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25.0,
                  ), // Aligns button with the text field
                  child: ElevatedButton(
                    onPressed: controller.addBenefit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.benefits.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    controller.benefits.length,
                    (index) => _buildRemovableChip(
                      controller.benefits[index],
                      () => controller.removeBenefit(index),
                      isSuccessTheme:
                          true, // Makes it green like the original UI
                    ),
                  ),
                ),
              );
            }),
          ],
        ),

        // 3. Required Skills
        StepSectionCard(
          title: 'Required Skills',
          icon: Icons.psychology_outlined,
          children: [
            FormFieldWrapper(
              label: 'Select Skills',
              required: true, // Marked as required since submitJob checks it
              child: CitySelectField<MasterDataItem>(
                controller: controller.skillNameCtrl,
                fetchOptions: controller.fetchSkills,
                labelOf: (item) => item.name,
                hintText: "Search and add skills",
                prefixIcon: Icons.search_rounded,
                sheetTitle: "Select Skill",
                searchHint: "Search for skills...",
                onSelected: (item) {
                  controller.addSkill(item.id, item.name);
                  controller.skillNameCtrl
                      .clear(); // Clear input so they can add more
                },
              ),
            ),
            Obx(() {
              if (controller.selectedSkillNames.isEmpty)
                return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    controller.selectedSkillNames.length,
                    (index) => _buildRemovableChip(
                      controller.selectedSkillNames[index],
                      () => controller.removeSkill(index),
                      isSuccessTheme: false, // Makes it blue for skills
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  // Helper widget to render those nice pill-shaped chips
  Widget _buildRemovableChip(
    String label,
    VoidCallback onRemove, {
    required bool isSuccessTheme,
  }) {
    final Color bgColor = isSuccessTheme
        ? const Color(0xFFDCFCE7)
        : AppColors.primaryLight;
    final Color textColor = isSuccessTheme
        ? const Color(0xFF166534)
        : AppColors.primary;
    final Color borderColor = isSuccessTheme
        ? const Color(0xFF86EFAC)
        : AppColors.primary.withAlpha(77);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: textColor.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// STEP 4: SCHEDULE & CONTACT
// ==========================================
class Step4ScheduleWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step4ScheduleWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Schedule & Contact',
          'Set working schedule and how candidates can reach you',
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Working Schedule',
          icon: Icons.schedule_outlined,
          children: [
            FormFieldWrapper(
              label: 'Working Days',
              required: true,
              child: StyledDropdown(
                value: controller.workingDaysCtrl.text.isEmpty
                    ? null
                    : controller.workingDaysCtrl.text,
                items: controller.workingDaysOptions
                    .map((e) => e.name)
                    .toList(),
                hint: 'Select working days',
                prefixIcon: Icons.calendar_today_outlined,
                onChanged: (v) => controller.workingDaysCtrl.text = v ?? '',
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Working Hours',
              required: true,
              child: StyledDropdown(
                value: controller.workingHoursCtrl.text.isEmpty
                    ? null
                    : controller.workingHoursCtrl.text,
                items: controller.workingHoursOptions
                    .map((e) => e.name)
                    .toList(),
                hint: 'Select working hours',
                prefixIcon: Icons.access_time_outlined,
                onChanged: (v) => controller.workingHoursCtrl.text = v ?? '',
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Application Closing Date',
              required: true,
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(
                          context,
                        ).colorScheme.copyWith(primary: AppColors.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null)
                    controller.closingDate.value = picked.toIso8601String();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _outlineLight, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: _onSurfaceMuted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() {
                          final dateStr = controller.closingDate.value;
                          final date = dateStr.isNotEmpty
                              ? DateTime.tryParse(dateStr)
                              : null;
                          return Text(
                            date != null
                                ? '${date.day}/${date.month}/${date.year}'
                                : 'Select closing date',
                            style: TextStyle(
                              fontSize: 14,
                              color: date != null
                                  ? const Color(0xFF0F172A)
                                  : _onSurfaceMuted,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Contact Information',
          icon: Icons.contact_mail_outlined,
          children: [
            FormFieldWrapper(
              label: 'Contact Email',
              required: true,
              child: TextFormField(
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14),
                decoration: _inputDecoration(
                  hint: 'hr@yourcompany.com',
                  icon: Icons.email_outlined,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Telegram Username',
              child: TextFormField(
                controller: controller.telegramCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: _inputDecoration(
                  hint: '@hrteam',
                  icon: Icons.telegram,
                ),
              ),
            ),
          ],
        ),

        // Final Ready to Post Review Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warning.withAlpha(77)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ready to Post?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review all information before posting your job. Once published, job seekers can immediately apply.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning.withBlue(50),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// REUSABLE COMPONENTS
// ==========================================

Widget _buildStepHeader(BuildContext context, String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: _onSurfaceSecondary),
      ),
    ],
  );
}

InputDecoration _inputDecoration({
  required String hint,
  IconData? icon,
  String? prefix,
}) {
  return InputDecoration(
    hintText: hint,
    prefixText: prefix,
    prefixStyle: const TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),
    prefixIcon: icon != null
        ? Icon(icon, size: 18, color: _onSurfaceMuted)
        : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _outlineLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _outlineLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );
}

class FormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;

  const FormFieldWrapper({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class StyledDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final IconData prefixIcon;
  final ValueChanged<String?> onChanged;

  const StyledDropdown({
    super.key,
    this.value,
    required this.items,
    required this.hint,
    required this.prefixIcon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outlineLight, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(prefixIcon, size: 16, color: _onSurfaceMuted),
              const SizedBox(width: 8),
              Text(
                hint,
                style: const TextStyle(fontSize: 14, color: _onSurfaceMuted),
              ),
            ],
          ),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(12),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class StepSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const StepSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class StepperWidget extends StatelessWidget {
  final int currentStep;
  const StepperWidget({super.key, required this.currentStep});

  static const List<Map<String, dynamic>> _steps = [
    {'label': 'Basic Info', 'icon': Icons.work_outline_rounded},
    {'label': 'Salary', 'icon': Icons.attach_money_rounded},
    {'label': 'Details', 'icon': Icons.description_outlined},
    {'label': 'Schedule', 'icon': Icons.schedule_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final isCompleted = (index ~/ 2) < currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : _outlineLight,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isCompleted = stepIndex < currentStep;
        final isActive = stepIndex == currentStep;

        Color bgColor = isCompleted
            ? AppColors.primary
            : isActive
            ? _primaryContainer
            : _surfaceVariantLight;
        Color iconColor = isCompleted
            ? Colors.white
            : isActive
            ? AppColors.primary
            : _onSurfaceMuted;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(64),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : Icon(
                        _steps[stepIndex]['icon'] as IconData,
                        color: iconColor,
                        size: 16,
                      ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _steps[stepIndex]['label'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive || isCompleted
                    ? AppColors.primary
                    : _onSurfaceMuted,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class StickyNavBarWidget extends StatelessWidget {
  final int currentStep;
  final bool isPosting;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  const StickyNavBarWidget({
    super.key,
    required this.currentStep,
    required this.isPosting,
    this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == 3;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onPrevious != null) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: _outlineLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: onPrevious != null ? 1 : 2,
            child: ElevatedButton(
              onPressed: isPosting ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastStep
                    ? AppColors.success
                    : AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isPosting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastStep ? 'Post Job' : 'Next Step',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLastStep
                              ? Icons.check_circle_outline_rounded
                              : Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
