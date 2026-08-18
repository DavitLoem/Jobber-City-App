import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/location_services.dart';
import 'package:jobber_city/core/api/services/role/employer/job_post_services.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/location_model.dart';
import 'package:jobber_city/models/role/employer/job_post_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/widget/city_select_field.dart';
import 'package:jobber_city/widgets/arrow_key_back.dart';

part 'post_job_screen_binding.dart';
part 'post_job_screen_controller.dart';

const _outlineLight = Color(0xFFE2E8F0);
const _onSurfaceMuted = Color(0xFF64748B);
const _onSurfaceSecondary = Color(0xFF475569);
const _surfaceVariantLight = Color(0xFFF1F5F9);
const _primaryContainer = Color(0xFFEEF2FF);

class PostJobScreenView extends GetView<PostJobScreenViewController> {
  const PostJobScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ArrowKeyBack(),
        ),
        title: Text(
          "Post a Job".tr,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(
          alpha: 0.05,
        ), // 🟢 Updated to withValues
        shape: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkDivider : _outlineLight,
            width: 1,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(
                          alpha: 0.15,
                        ) // 🟢 Updated to withValues
                      : _primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Save Draft'.tr,
                  style: const TextStyle(
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
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: StepperWidget(currentStep: controller.currentStep.value),
              ),

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

              StickyNavBarWidget(
                currentStep: controller.currentStep.value,
                isPosting: controller.isLoading.value,
                onPrevious: controller.currentStep.value > 0
                    ? () => controller.previousStep()
                    : null,
                onNext: () => controller.nextStep(),
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
          'Basic Information'.tr,
          'Tell us about the role and where it\'s based'.tr,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Company & Position'.tr,
          icon: Icons.business_center_outlined,
          children: [
            _buildLogoSection(context),
            const SizedBox(height: 16),
            FormFieldWrapper(
              label: 'Job Title'.tr,
              required: true,
              child: TextFormField(
                controller: controller.titleCtrl,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'e.g. Senior Product Designer'.tr,
                  icon: Icons.work_outline_rounded,
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Location'.tr,
          icon: Icons.location_on_outlined,
          children: [
            FormFieldWrapper(
              label: 'Province / State'.tr,
              required: true,
              child: CitySelectField<LocationModel>(
                controller: controller.provinceCtrl,
                fetchOptions: () => Future.value([]),
                labelOf: (loc) => loc.nameEn,
                hintText: "Select province".tr,
                sheetTitle: "Select Province".tr,
                searchHint: "Search province...".tr,
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
                label: 'District / City'.tr,
                required: true,
                child: CitySelectField<LocationModel>(
                  controller: controller.districtCtrl,
                  fetchOptions: controller.provinceId.value.isEmpty
                      ? () async => []
                      : () => LocationServices().getDistricts(
                          controller.provinceId.value,
                        ),
                  labelOf: (dist) => dist.nameEn,
                  hintText: controller.provinceId.value.isEmpty
                      ? "Select province first".tr
                      : "Select district".tr,
                  sheetTitle: "Select District".tr,
                  searchHint: "Search district...".tr,
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
      ],
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FormFieldWrapper(
      label: 'Company Logo'.tr,
      child: Obx(() {
        final hasLogo = controller.companyLogoUrl.value.isNotEmpty;

        return InkWell(
          onTap: () {
            Get.snackbar("Upload".tr, "Wire this to your image picker.".tr);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkInputBackground
                  : _surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : _outlineLight,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: hasLogo
                        ? (isDark ? AppColors.darkSurface : Colors.white)
                        : (isDark
                              ? AppColors.primary.withValues(
                                  alpha: 0.15,
                                ) // 🟢 Updated to withValues
                              : _primaryContainer),
                    borderRadius: BorderRadius.circular(10),
                    border: hasLogo
                        ? Border.all(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : _outlineLight,
                          )
                        : null,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasLogo
                            ? 'Company Logo Applied'.tr
                            : 'Upload Company Logo'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasLogo
                            ? 'Fetched directly from your profile'.tr
                            : 'Tap to browse (PNG, JPG up to 5MB)'.tr,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : _onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLogo)
                  Icon(
                    Icons.check_circle_rounded,
                    color: isDark ? Colors.greenAccent : Colors.green,
                    size: 22,
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : _outlineLight,
                      ),
                    ),
                    child: Text(
                      'Browse'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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

class Step2SalaryWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step2SalaryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Salary & Requirements'.tr,
          'Define compensation and candidate requirements'.tr,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Compensation'.tr,
          icon: Icons.attach_money_rounded,
          children: [
            FormFieldWrapper(
              label: 'Salary Period'.tr,
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
                                : (isDark
                                      ? AppColors.darkSurfaceElevated
                                      : _surfaceVariantLight),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.darkCardBorder
                                        : _outlineLight),
                            ),
                          ),
                          child: Text(
                            p.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkTextSecondary
                                        : _onSurfaceSecondary),
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
                    label: 'Minimum Salary'.tr,
                    required: true,
                    child: TextFormField(
                      controller: controller.minSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      decoration: _inputDecoration(
                        context,
                        hint: '500',
                        prefix: '\$ ',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Maximum Salary'.tr,
                    required: true,
                    child: TextFormField(
                      controller: controller.maxSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      decoration: _inputDecoration(
                        context,
                        hint: '1000',
                        prefix: '\$ ',
                      ),
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
                      ? (isDark
                            ? AppColors.primary.withValues(
                                alpha: 0.15,
                              ) // 🟢 Updated to withValues
                            : _primaryContainer)
                      : (isDark
                            ? AppColors.darkInputBackground
                            : _surfaceVariantLight),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isNegotiable.value
                        ? AppColors.primary.withValues(
                            alpha: 0.5,
                          ) // 🟢 Updated to withValues
                        : (isDark ? AppColors.darkCardBorder : _outlineLight),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      size: 18,
                      color: controller.isNegotiable.value
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkIconSecondary
                                : _onSurfaceMuted),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Negotiable Salary'.tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.isNegotiable.value
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.darkTextSecondary
                                        : const Color(0xFF374151)),
                            ),
                          ),
                          Text(
                            'Candidates can negotiate final offer'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextHint
                                  : _onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isNegotiable.value,
                      onChanged: (v) => controller.isNegotiable.value = v,
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: isDark
                          ? AppColors.primary.withValues(
                              alpha: 0.5,
                            ) // 🟢 Updated to withValues
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Requirements'.tr,
          icon: Icons.school_outlined,
          children: [
            FormFieldWrapper(
              label: 'Number of Vacancies'.tr,
              required: true,
              child: TextFormField(
                controller: controller.headCountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'e.g. 3'.tr,
                  icon: Icons.people_outline_rounded,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Experience Required'.tr,
              required: true,
              child: StyledDropdown(
                value: controller.experienceCtrl.text.isEmpty
                    ? null
                    : controller.experienceCtrl.text,
                items: controller.experienceOptions.map((e) => e.name).toList(),
                hint: 'Select experience level'.tr,
                prefixIcon: Icons.timeline_outlined,
                onChanged: (v) => controller.experienceCtrl.text = v ?? '',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Step3DetailsWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step3DetailsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Job Details'.tr,
          'Describe the role, requirements, and what you offer'.tr,
        ),
        const SizedBox(height: 16),

        StepSectionCard(
          title: 'Job Description'.tr,
          icon: Icons.description_outlined,
          children: [
            FormFieldWrapper(
              label: 'Job Description'.tr,
              required: true,
              child: TextFormField(
                controller: controller.descCtrl,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'Describe the role, responsibilities, and tasks...'.tr,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Minimum Qualifications'.tr,
              required: true,
              child: TextFormField(
                controller: controller.reqCtrl,
                maxLines: 4,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'List required education, skills, and experience...'.tr,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'About the Company'.tr,
              child: TextFormField(
                controller: controller.aboutCompanyCtrl,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'Share your company culture, mission, and values...'.tr,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
          ],
        ),

        StepSectionCard(
          title: 'Benefits & Perks'.tr,
          icon: Icons.card_giftcard_outlined,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Add Benefits'.tr,
                    child: TextFormField(
                      controller: controller.benefitInputCtrl,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      decoration: _inputDecoration(
                        context,
                        hint: 'e.g. Health Insurance'.tr,
                        icon: Icons.add_circle_outline_rounded,
                      ),
                      onFieldSubmitted: (_) => controller.addBenefit(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
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
                    child: Text(
                      'Add'.tr,
                      style: const TextStyle(
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
                      isSuccessTheme: true,
                      isDark: isDark,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),

        StepSectionCard(
          title: 'Required Skills'.tr,
          icon: Icons.psychology_outlined,
          children: [
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
                      isSuccessTheme: false,
                      isDark: isDark,
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

  Widget _buildRemovableChip(
    String label,
    VoidCallback onRemove, {
    required bool isSuccessTheme,
    required bool isDark,
  }) {
    final Color bgColor = isSuccessTheme
        ? (isDark
              ? Colors.greenAccent.withValues(
                  alpha: 0.15,
                ) // 🟢 Updated to withValues
              : const Color(0xFFDCFCE7))
        : (isDark
              ? AppColors.primary.withValues(
                  alpha: 0.2,
                ) // 🟢 Updated to withValues
              : AppColors.primaryLight);
    final Color textColor = isSuccessTheme
        ? (isDark ? Colors.greenAccent : const Color(0xFF166534))
        : (isDark ? Colors.blueAccent : AppColors.primary);
    final Color borderColor = isSuccessTheme
        ? (isDark
              ? Colors.greenAccent.withValues(
                  alpha: 0.3,
                ) // 🟢 Updated to withValues
              : const Color(0xFF86EFAC))
        : (isDark
              ? Colors.blueAccent.withValues(
                  alpha: 0.3,
                ) // 🟢 Updated to withValues
              : AppColors.primary.withAlpha(77));

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

class Step4ScheduleWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  const Step4ScheduleWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Schedule & Contact'.tr,
          'Set working schedule and how candidates can reach you'.tr,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Working Schedule'.tr,
          icon: Icons.schedule_outlined,
          children: [
            FormFieldWrapper(
              label: 'Working Days'.tr,
              required: true,
              child: StyledDropdown(
                value: controller.workingDaysCtrl.text.isEmpty
                    ? null
                    : controller.workingDaysCtrl.text,
                items: controller.workingDaysOptions
                    .map((e) => e.name)
                    .toList(),
                hint: 'Select working days'.tr,
                prefixIcon: Icons.calendar_today_outlined,
                onChanged: (v) => controller.workingDaysCtrl.text = v ?? '',
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Working Hours'.tr,
              required: true,
              child: StyledDropdown(
                value: controller.workingHoursCtrl.text.isEmpty
                    ? null
                    : controller.workingHoursCtrl.text,
                items: controller.workingHoursOptions
                    .map((e) => e.name)
                    .toList(),
                hint: 'Select working hours'.tr,
                prefixIcon: Icons.access_time_outlined,
                onChanged: (v) => controller.workingHoursCtrl.text = v ?? '',
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Application Closing Date'.tr,
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
                    color: isDark
                        ? AppColors.darkInputBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkCardBorder : _outlineLight,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: isDark
                            ? AppColors.darkIconSecondary
                            : _onSurfaceMuted,
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
                                : 'Select closing date'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: date != null
                                  ? (isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A))
                                  : (isDark
                                        ? AppColors.darkTextHint
                                        : _onSurfaceMuted),
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
          title: 'Contact Information'.tr,
          icon: Icons.contact_mail_outlined,
          children: [
            FormFieldWrapper(
              label: 'Contact Email'.tr,
              required: true,
              child: TextFormField(
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'hr@yourcompany.com',
                  icon: Icons.email_outlined,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Telegram Username'.tr,
              child: TextFormField(
                controller: controller.telegramCtrl,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: '@hrteam',
                  icon: Icons.telegram,
                ),
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.orangeAccent.withValues(
                    alpha: 0.1,
                  ) // 🟢 Updated to withValues
                : const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.orangeAccent.withValues(
                      alpha: 0.3,
                    ) // 🟢 Updated to withValues
                  : AppColors.warning.withAlpha(77),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: isDark ? Colors.orangeAccent : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Post?'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.orangeAccent : AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review all information before posting your job. Once published, job seekers can immediately apply.'
                          .tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.orangeAccent.shade100
                            : AppColors.warning.withBlue(50),
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

Widget _buildStepHeader(BuildContext context, String title, String subtitle) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkTextSecondary : _onSurfaceSecondary,
        ),
      ),
    ],
  );
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String hint,
  IconData? icon,
  String? prefix,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InputDecoration(
    hintText: hint,
    prefixText: prefix,
    prefixStyle: TextStyle(
      color: isDark ? Colors.blueAccent : AppColors.primary,
      fontWeight: FontWeight.w600,
    ),
    prefixIcon: icon != null
        ? Icon(
            icon,
            size: 18,
            color: isDark ? AppColors.darkIconSecondary : _onSurfaceMuted,
          )
        : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: isDark ? AppColors.darkInputBackground : Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? AppColors.darkCardBorder : _outlineLight,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? AppColors.darkCardBorder : _outlineLight,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    hintStyle: TextStyle(
      color: isDark ? AppColors.darkTextHint : _onSurfaceMuted,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : const Color(0xFF374151),
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: isDark ? Colors.redAccent : AppColors.error,
                      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : _outlineLight,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Theme.of(context).cardColor,
          hint: Row(
            children: [
              Icon(
                prefixIcon,
                size: 16,
                color: isDark ? AppColors.darkIconSecondary : _onSurfaceMuted,
              ),
              const SizedBox(width: 8),
              Text(
                hint,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextHint : _onSurfaceMuted,
                ),
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
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.2 : 0.05,
            ), // 🟢 Updated to withValues
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
                    color: isDark
                        ? AppColors.primary.withValues(
                            alpha: 0.15,
                          ) // 🟢 Updated to withValues
                        : _primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
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

  static List<Map<String, dynamic>> get _steps => [
    {'label': 'Basic Info'.tr, 'icon': Icons.work_outline_rounded},
    {'label': 'Salary'.tr, 'icon': Icons.attach_money_rounded},
    {'label': 'Details'.tr, 'icon': Icons.description_outlined},
    {'label': 'Schedule'.tr, 'icon': Icons.schedule_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(_steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final isCompleted = (index ~/ 2) < currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primary
                    : (isDark ? AppColors.darkDivider : _outlineLight),
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
            ? (isDark
                  ? AppColors.primary.withValues(
                      alpha: 0.2,
                    ) // 🟢 Updated to withValues
                  : _primaryContainer)
            : (isDark ? AppColors.darkSurfaceElevated : _surfaceVariantLight);
        Color iconColor = isCompleted
            ? Colors.white
            : isActive
            ? AppColors.primary
            : (isDark ? AppColors.darkIconSecondary : _onSurfaceMuted);

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
                    : (isDark && !isCompleted
                          ? Border.all(color: AppColors.darkCardBorder)
                          : null),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: 0.25,
                          ), // 🟢 Updated to withValues
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
                    : (isDark ? AppColors.darkTextHint : _onSurfaceMuted),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : Colors.transparent,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Updated to withValues
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
                label: Text('Previous'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: isDark ? AppColors.darkCardBorder : _outlineLight,
                  ),
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
                    ? (isDark ? Colors.greenAccent : AppColors.success)
                    : AppColors.primary,
                foregroundColor: isLastStep && isDark
                    ? Colors.black87
                    : Colors.white,
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
                          isLastStep ? 'Post Job'.tr : 'Next Step'.tr,
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
