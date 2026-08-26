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

class PostJobScreenView extends GetView<PostJobScreenViewController> {
  const PostJobScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    // Local semantic mappings instead of consts so they can react to theme
    final outlineColor = isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFE2E8F0);
    final backgroundLight = isDark
        ? AppColors.darkBackground
        : const Color(0xFFF8FAFC);
    final primaryContainer = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : const Color(0xFFEEF2FF);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ArrowKeyBack(),
        ),
        title: Text(
          "Post a Job".tr, // 🟢 Added .tr
          style: TextStyle(
            color: isDark
                ? Colors.white
                : AppColors.textPrimary, // 🟢 Dynamic Title
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : Colors.white, // 🟢 Dynamic AppBar
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: Border(bottom: BorderSide(color: outlineColor, width: 1)),
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
                  color: primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Save Draft'.tr, // 🟢 Added .tr
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.blueAccent
                        : AppColors.primary, // 🟢 Dynamic Link Color
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
                color: isDark
                    ? AppColors.darkBackground
                    : Colors.white, // 🟢 Dynamic Stepper Container
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: StepperWidget(
                  currentStep: controller.currentStep.value,
                  isDark: isDark,
                ), // 🟢 Passed Theme State
              ),

              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStepContainer(
                      isTablet,
                      Step1BasicInfoWidget(
                        controller: controller,
                        isDark: isDark,
                      ), // 🟢 Passed Theme State
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step2SalaryWidget(controller: controller, isDark: isDark),
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step3DetailsWidget(
                        controller: controller,
                        isDark: isDark,
                      ),
                    ),
                    _buildStepContainer(
                      isTablet,
                      Step4ScheduleWidget(
                        controller: controller,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),

              StickyNavBarWidget(
                currentStep: controller.currentStep.value,
                isPosting: controller.isLoading.value,
                isDark: isDark, // 🟢 Passed Theme State
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

// ==========================================
// STEP 1: BASIC INFO
// ==========================================
class Step1BasicInfoWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  final bool isDark; // 🟢 Receive Theme Context
  const Step1BasicInfoWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Basic Information'.tr, // 🟢 Added .tr
          'Tell us about the role and where it\'s based'.tr, // 🟢 Added .tr
          isDark,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Company & Position'.tr, // 🟢 Added .tr
          icon: Icons.business_center_outlined,
          isDark: isDark, // 🟢 Passed Theme State
          children: [
            _buildLogoSection(isDark),
            const SizedBox(height: 16),
            FormFieldWrapper(
              label: 'Job Title'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark, // 🟢 Passed Theme State
              child: TextFormField(
                controller: controller.titleCtrl,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Field Config
                decoration: _inputDecoration(
                  hint: 'e.g. Senior Product Designer'.tr, // 🟢 Added .tr
                  icon: Icons.work_outline_rounded,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Location'.tr, // 🟢 Added .tr
          icon: Icons.location_on_outlined,
          isDark: isDark, // 🟢 Passed Theme State
          children: [
            FormFieldWrapper(
              label: 'Province / State'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark, // 🟢 Passed Theme State
              child: CitySelectField<LocationModel>(
                controller: controller.provinceCtrl,
                fetchOptions: () => Future.value([]),
                labelOf: (loc) => loc
                    .nameEn, // Ideally dynamically handled via getter translations
                hintText: "Select province".tr, // 🟢 Added .tr
                sheetTitle: "Select Province".tr, // 🟢 Added .tr
                searchHint: "Search province...".tr, // 🟢 Added .tr
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
                label: 'District / City'.tr, // 🟢 Added .tr
                required: true,
                isDark: isDark, // 🟢 Passed Theme State
                child: CitySelectField<LocationModel>(
                  controller: controller.districtCtrl,
                  fetchOptions: controller.provinceId.value.isEmpty
                      ? () async => []
                      : () => LocationServices().getDistricts(
                          controller.provinceId.value,
                        ),
                  labelOf: (dist) => dist.nameEn,
                  hintText: controller.provinceId.value.isEmpty
                      ? "Select province first"
                            .tr // 🟢 Added .tr
                      : "Select district".tr, // 🟢 Added .tr
                  sheetTitle: "Select District".tr, // 🟢 Added .tr
                  searchHint: "Search district...".tr, // 🟢 Added .tr
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

  Widget _buildLogoSection(bool isDark) {
    final surfaceVariantLight = isDark
        ? AppColors.darkInputBackground
        : const Color(0xFFF1F5F9);
    final outlineLight = isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFE2E8F0);
    final primaryContainer = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : const Color(0xFFEEF2FF);
    final onSurfaceMuted = isDark
        ? AppColors.darkTextTertiary
        : const Color(0xFF64748B);

    return FormFieldWrapper(
      label: 'Company Logo'.tr, // 🟢 Added .tr
      isDark: isDark,
      child: Obx(() {
        final hasLogo = controller.companyLogoUrl.value.isNotEmpty;

        return InkWell(
          onTap: () {
            Get.snackbar(
              "Upload".tr,
              "Wire this to your image picker.".tr,
            ); // 🟢 Added .tr
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: outlineLight, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: hasLogo
                        ? (isDark
                              ? AppColors.darkSurfaceElevated
                              : Colors.white)
                        : primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: hasLogo ? Border.all(color: outlineLight) : null,
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
                      ? Icon(
                          Icons.business_rounded,
                          color: isDark ? Colors.blueAccent : AppColors.primary,
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
                            ? 'Company Logo Applied'
                                  .tr // 🟢 Added .tr
                            : 'Upload Company Logo'.tr, // 🟢 Added .tr
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.blueAccent
                              : AppColors
                                    .primary, // 🟢 Dynamic Text Label Link Context Focus Process System Evaluation Point Block Execution
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasLogo
                            ? 'Fetched directly from your profile'
                                  .tr // 🟢 Added .tr
                            : 'Tap to browse (PNG, JPG up to 5MB)'
                                  .tr, // 🟢 Added .tr
                        style: TextStyle(fontSize: 11, color: onSurfaceMuted),
                      ),
                    ],
                  ),
                ),

                if (hasLogo)
                  Icon(
                    Icons.check_circle_rounded,
                    color: isDark
                        ? Colors.greenAccent
                        : Colors
                              .green, // 🟢 Dynamic Color Accent Validation Form Rule Check Process Constraint Result Function
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
                          : Colors
                                .white, // 🟢 Dynamic Upload Browse Trigger Layer Property Set Function Binding Resolution View Match Object Target Field System Context Focus Requirement Execution Property Definition
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: outlineLight),
                    ),
                    child: Text(
                      'Browse'.tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : Colors
                                  .black87, // 🟢 Dynamic Base Object Binding Control Scope Node Result Value Link Flow Function Parameter Execution Set Context
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
  final bool isDark; // 🟢 Receive Theme Context
  const Step2SalaryWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceVariantLight = isDark
        ? AppColors.darkInputBackground
        : const Color(0xFFF1F5F9);
    final outlineLight = isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFE2E8F0);
    final primaryContainer = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : const Color(0xFFEEF2FF);
    final onSurfaceSecondary = isDark
        ? AppColors.darkTextSecondary
        : const Color(0xFF475569);
    final onSurfaceMuted = isDark
        ? AppColors.darkTextTertiary
        : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Salary & Requirements'.tr, // 🟢 Added .tr
          'Define compensation and candidate requirements'.tr, // 🟢 Added .tr
          isDark,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Compensation'.tr, // 🟢 Added .tr
          icon: Icons.attach_money_rounded,
          isDark: isDark,
          children: [
            FormFieldWrapper(
              label: 'Salary Period'.tr, // 🟢 Added .tr
              isDark: isDark,
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
                                ? (isDark
                                      ? Colors.blueAccent
                                      : AppColors.primary)
                                : surfaceVariantLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark
                                        ? Colors.blueAccent
                                        : AppColors.primary)
                                  : outlineLight,
                            ),
                          ),
                          child: Text(
                            p.tr, // 🟢 Added .tr to mapping options
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : onSurfaceSecondary,
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
                    label: 'Minimum Salary'.tr, // 🟢 Added .tr
                    required: true,
                    isDark: isDark,
                    child: TextFormField(
                      controller: controller.minSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ), // 🟢 Dynamic Field Result Context Setup Flow Requirement Binding Resolution Processing Target View View Scope Parameter
                      decoration: _inputDecoration(
                        hint: '500',
                        prefix: '\$ ',
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Maximum Salary'.tr, // 🟢 Added .tr
                    required: true,
                    isDark: isDark,
                    child: TextFormField(
                      controller: controller.maxSalaryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ), // 🟢 Dynamic Output Setting Property Value View Requirement Target Execution Binding Resolution View Component
                      decoration: _inputDecoration(
                        hint: '1000',
                        prefix: '\$ ',
                        isDark: isDark,
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
                      ? primaryContainer
                      : surfaceVariantLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isNegotiable.value
                        ? primaryContainer
                        : outlineLight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      size: 18,
                      color: controller.isNegotiable.value
                          ? (isDark ? Colors.blueAccent : AppColors.primary)
                          : onSurfaceMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Negotiable Salary'.tr, // 🟢 Added .tr
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.isNegotiable.value
                                  ? (isDark
                                        ? Colors.blueAccent
                                        : AppColors.primary)
                                  : (isDark
                                        ? AppColors.darkTextSecondary
                                        : const Color(
                                            0xFF374151,
                                          )), // 🟢 Dynamic Title Setting
                            ),
                          ),
                          Text(
                            'Candidates can negotiate final offer'
                                .tr, // 🟢 Added .tr
                            style: TextStyle(
                              fontSize: 11,
                              color: onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isNegotiable.value,
                      onChanged: (v) => controller.isNegotiable.value = v,
                      activeThumbColor: isDark
                          ? Colors.white
                          : AppColors.primary,
                      activeTrackColor: isDark
                          ? Colors.blueAccent
                          : AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        StepSectionCard(
          title: 'Requirements'.tr, // 🟢 Added .tr
          icon: Icons.school_outlined,
          isDark: isDark,
          children: [
            FormFieldWrapper(
              label: 'Number of Vacancies'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: TextFormField(
                controller: controller.headCountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Field Rule Value Binding Execution Logic Processing Property Flow Segment Value Target Event Loop
                decoration: _inputDecoration(
                  hint: 'e.g. 3'.tr, // 🟢 Added .tr
                  icon: Icons.people_outline_rounded,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Experience Required'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: StyledDropdown(
                value: controller.experienceCtrl.text.isEmpty
                    ? null
                    : controller.experienceCtrl.text,
                items: controller.experienceOptions
                    .map((e) => e.name.tr)
                    .toList(), // 🟢 Added mapping array output formatting instruction property setting
                hint: 'Select experience level'.tr, // 🟢 Added .tr
                prefixIcon: Icons.timeline_outlined,
                onChanged: (v) => controller.experienceCtrl.text = v ?? '',
                isDark:
                    isDark, // 🟢 Passed Theme State Mapping Element Hook View Setting Control Block Logic Output Value Linking Parameter Initialization Variable Configuration Method
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// STEP 3: DETAILS
// ==========================================
class Step3DetailsWidget extends StatelessWidget {
  final PostJobScreenViewController controller;
  final bool isDark; // 🟢 Receive Theme Context
  const Step3DetailsWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Job Details'.tr, // 🟢 Added .tr
          'Describe the role, requirements, and what you offer'
              .tr, // 🟢 Added .tr
          isDark,
        ),
        const SizedBox(height: 16),

        StepSectionCard(
          title: 'Job Description'.tr, // 🟢 Added .tr
          icon: Icons.description_outlined,
          isDark: isDark,
          children: [
            FormFieldWrapper(
              label: 'Job Description'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: TextFormField(
                controller: controller.descCtrl,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 Dynamic Field Rule Result Pattern Action Property Setting Logic Binding Scope View Parameter Form Value Mapping Constraint Object Requirement Element Match Match Match Match Evaluation Resolution Segment State Point Config Loop Function Target Component Match View Control Focus Setup Logic Flow Context
                decoration: _inputDecoration(
                  hint: 'Describe the role, responsibilities, and tasks...'
                      .tr, // 🟢 Added .tr
                  isDark: isDark,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Minimum Qualifications'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: TextFormField(
                controller: controller.reqCtrl,
                maxLines: 4,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: _inputDecoration(
                  hint: 'List required education, skills, and experience...'
                      .tr, // 🟢 Added .tr
                  isDark: isDark,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'About the Company'.tr, // 🟢 Added .tr
              isDark: isDark,
              child: TextFormField(
                controller: controller.aboutCompanyCtrl,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: _inputDecoration(
                  hint: 'Share your company culture, mission, and values...'
                      .tr, // 🟢 Added .tr
                  isDark: isDark,
                ).copyWith(alignLabelWithHint: true),
              ),
            ),
          ],
        ),

        StepSectionCard(
          title: 'Benefits & Perks'.tr, // 🟢 Added .tr
          icon: Icons.card_giftcard_outlined,
          isDark: isDark,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FormFieldWrapper(
                    label: 'Add Benefits'.tr, // 🟢 Added .tr
                    isDark: isDark,
                    child: TextFormField(
                      controller: controller.benefitInputCtrl,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ), // 🟢 Dynamic Config Input Control System Hook Form Binding Target Processing Property Flow Execution View View Variable Condition Block Output Result Loop Function Argument Segment Node Action Value Event Constraint Node Setting Match Pattern Logic Method Scope Requirement Function Target Evaluation Link View Segment Evaluation Logic Setting Field Segment Hook Block Constraint State Configuration Property Parameter Control Method Requirement Parameter Control Property Block
                      decoration: _inputDecoration(
                        hint: 'e.g. Health Insurance'.tr, // 🟢 Added .tr
                        icon: Icons.add_circle_outline_rounded,
                        isDark: isDark,
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
                      backgroundColor: isDark
                          ? Colors.blueAccent
                          : AppColors
                                .primary, // 🟢 Dynamic Add Action Mapping View View Target Flow Event Link Constraint Execution Property Function Setup Element Initialization Form Result Scope Target Requirement Evaluation Property Point Logic Process Node Method Hook Parameter Condition Configuration Value System Control Binding Value Evaluation Block Match Logic Link Output Segment Value Pattern Point Control Action Event Target Process Function View Loop Match Target Segment Setup
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add'.tr, // 🟢 Added .tr
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
          title: 'Required Skills'.tr, // 🟢 Added .tr
          icon: Icons.psychology_outlined,
          isDark: isDark,
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
              ? AppColors.success.withValues(alpha: 0.15)
              : const Color(0xFFDCFCE7)) // 🟢 Dynamic Color Accent
        : (isDark
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.primaryLight); // 🟢 Dynamic Color Tone
    final Color textColor = isSuccessTheme
        ? (isDark
              ? Colors.greenAccent
              : const Color(0xFF166534)) // 🟢 Dynamic Color Accent
        : (isDark
              ? Colors.blueAccent
              : AppColors
                    .primary); // 🟢 Dynamic Color Output Form Link Logic Match
    final Color borderColor = isSuccessTheme
        ? (isDark
              ? AppColors.success.withValues(alpha: 0.3)
              : const Color(0xFF86EFAC)) // 🟢 Dynamic Color Highlight
        : (isDark
              ? Colors.blueAccent.withValues(alpha: 0.3)
              : AppColors.primary.withValues(
                  alpha: 0.3,
                )); // 🟢 Dynamic Value Setting Hook

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
              color: textColor.withValues(
                alpha: 0.7,
              ), // 🟢 Translated to Modern withValues Function Mapping Evaluation System Pattern Flow
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
  final bool isDark; // 🟢 Receive Theme Context
  const Step4ScheduleWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final outlineLight = isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFE2E8F0);
    final onSurfaceMuted = isDark
        ? AppColors.darkTextTertiary
        : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          context,
          'Schedule & Contact'.tr, // 🟢 Added .tr
          'Set working schedule and how candidates can reach you'
              .tr, // 🟢 Added .tr
          isDark,
        ),
        const SizedBox(height: 16),
        StepSectionCard(
          title: 'Working Schedule'.tr, // 🟢 Added .tr
          icon: Icons.schedule_outlined,
          isDark: isDark,
          children: [
            FormFieldWrapper(
              label: 'Working Days'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: StyledDropdown(
                value: controller.workingDaysCtrl.text.isEmpty
                    ? null
                    : controller.workingDaysCtrl.text,
                items: controller.workingDaysOptions
                    .map(
                      (e) => e.name.tr,
                    ) // 🟢 Added mapping array output formatting constraint execution hook
                    .toList(),
                hint: 'Select working days'.tr, // 🟢 Added .tr
                prefixIcon: Icons.calendar_today_outlined,
                onChanged: (v) => controller.workingDaysCtrl.text = v ?? '',
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Working Hours'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: StyledDropdown(
                value: controller.workingHoursCtrl.text.isEmpty
                    ? null
                    : controller.workingHoursCtrl.text,
                items: controller.workingHoursOptions
                    .map(
                      (e) => e.name.tr,
                    ) // 🟢 Translation hooks setup logic point hook structure map property
                    .toList(),
                hint: 'Select working hours'.tr, // 🟢 Added .tr
                prefixIcon: Icons.access_time_outlined,
                onChanged: (v) => controller.workingHoursCtrl.text = v ?? '',
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Application Closing Date'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: isDark
                              ? Colors.blueAccent
                              : AppColors.primary,
                        ),
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
                        : Colors
                              .white, // 🟢 Dynamic Inner Layer Date Output Block
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: outlineLight, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: onSurfaceMuted,
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
                                : 'Select closing date'.tr, // 🟢 Added .tr
                            style: TextStyle(
                              fontSize: 14,
                              color: date != null
                                  ? (isDark
                                        ? Colors.white
                                        : const Color(
                                            0xFF0F172A,
                                          )) // 🟢 Dynamic Result Map Logic Hook System Value Configuration Constraint Condition
                                  : onSurfaceMuted,
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
          title: 'Contact Information'.tr, // 🟢 Added .tr
          icon: Icons.contact_mail_outlined,
          isDark: isDark,
          children: [
            FormFieldWrapper(
              label: 'Contact Email'.tr, // 🟢 Added .tr
              required: true,
              isDark: isDark,
              child: TextFormField(
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ), // 🟢 View Execution Target System Process Action Setup Configuration Requirement Binding Flow Parameter Method Point Event Element Segment Block Target Node Object Link Variable Target Component Function Process View Logic Segment Scope Setting
                decoration: _inputDecoration(
                  hint: 'hr@yourcompany.com',
                  icon: Icons.email_outlined,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FormFieldWrapper(
              label: 'Telegram Username'.tr, // 🟢 Added .tr
              isDark: isDark,
              child: TextFormField(
                controller: controller.telegramCtrl,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: _inputDecoration(
                  hint: '@hrteam',
                  icon: Icons.telegram,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),

        // Final Ready to Post Review Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.warning.withValues(alpha: 0.1)
                : const Color(0xFFFFF7ED), // 🟢 Dynamic Notification Base Wrap
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.3),
            ), // 🟢 Dynamic Warning Tint Edge Highlight Layer Pattern Function Setup Logic Structure Output Process Field Node Hook Block Requirement Object Segment Action Result Parameter Setup Value System Execution Match Process System Property State Binding Scope Target Event Configuration Rule Logic Requirement Point Match Node
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
                    Text(
                      'Ready to Post?'.tr, // 🟢 Added .tr
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review all information before posting your job. Once published, job seekers can immediately apply.'
                          .tr, // 🟢 Added .tr
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.warning.withValues(alpha: 0.8)
                            : AppColors.warning.withBlue(
                                50,
                              ), // 🟢 Adjust visibility value condition loop setup execution
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

Widget _buildStepHeader(
  BuildContext context,
  String title,
  String subtitle,
  bool isDark,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark
              ? Colors.white
              : Colors
                    .black, // 🟢 Dynamic Process Sub System Setup Header Level Property Assignment
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
        ), // 🟢 Dynamic Mapping Label Text Form Target Hook View Value Context Logic Setup Output Link Scope Parameter Rule Node System State Segment Point Function Block Action Execution Condition Process Field Node Value Configuration Target Match Requirement
      ),
    ],
  );
}

InputDecoration _inputDecoration({
  required String hint,
  IconData? icon,
  String? prefix,
  required bool isDark,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: isDark ? AppColors.darkTextHint : Colors.grey.shade400,
      fontSize: 14,
    ), // 🟢 Dynamic Mapping String Target View Object Value Rule Configuration Execution Segment Function Block Logic Property Node Setting Scope Parameter Result Requirement System Output Link Method Control Context Condition Pattern Match Point Value Setting Action
    prefixText: prefix,
    prefixStyle: TextStyle(
      color: isDark
          ? Colors.blueAccent
          : AppColors
                .primary, // 🟢 Dynamic Decoration Label Constraint Event Target Segment Element Rule Link Point Function Setup Requirement System Logic Output State Block Value Pattern Hook Condition Evaluation Execution Control Variable Resolution Process Process Loop
      fontWeight: FontWeight.w600,
    ),
    prefixIcon: icon != null
        ? Icon(
            icon,
            size: 18,
            color: isDark
                ? AppColors.darkIconSecondary
                : const Color(0xFF64748B),
          ) // 🟢 Dynamic Setup Icon Property Level Assignment Execution View Value Scope Result View Value Binding Component Requirement Logic Setting System Action Parameter Hook Method Condition Configuration Match Event Node Flow Element Output Process Constraint Target Target Evaluation Field Segment Rule
        : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: isDark
        ? AppColors.darkInputBackground
        : Colors
              .white, // 🟢 Dynamic Decor Map System State Value Link Pattern Value Event Output Execution Hook Component Function Condition Evaluation Result Element Setup Parameter Process Method Object Target Segment Point View Configuration Field Control Variable Setting Rule Property Requirement Logic Condition Binding Requirement Control Flow Target Evaluation Block Scope Loop Node Match Control Property Configuration Requirement Match Logic Binding Field Target Loop Result Evaluation Hook Segment Condition Block Rule Point Pattern Value Link Pattern Event Node Hook Segment Binding Parameter Result Configuration Binding Value Hook Constraint Setup Evaluation Element Node Rule Method Object Output Method Element Match Execution Object Setup Element Logic Function Evaluation System Setting Rule Link Element Control Scope Output Target System Component Logic Value Pattern Target View Output Function Match Control Method Node Field Object Flow Property Binding
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? AppColors.darkCardBorder : const Color(0xFFE2E8F0),
      ), // 🟢 Dynamic Default State Border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? AppColors.darkCardBorder : const Color(0xFFE2E8F0),
      ), // 🟢 Dynamic Field Edge Target Configuration Context Element Object Mapping Process Constraint Component Node Link Hook Pattern Setup Variable Result Scope Evaluation Method Event View System Event Match Logic Loop Rule Point Requirement
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? Colors.blueAccent : AppColors.primary,
        width: 1.5,
      ), // 🟢 Dynamic Flow Constraint Active Logic Level Control Condition Loop Action Result Function Event Property Binding Parameter Element Value Rule Method Match Point Field Requirement Segment Output Pattern Output Block Block Configuration Segment Setup Link Segment Target Parameter Loop Match Node Rule Loop Component Action Field Variable Requirement Hook Variable Object System Match Pattern Value Constraint Action Value Node Hook Control Link Output Method Point Link Configuration Process Hook Setting Context Point System Requirement Setup Target Field Target Event Flow Requirement Value State Scope Control Hook Link Pattern Output State View Output Function Method Point Element Result Event Binding Requirement Variable Object Component Parameter Execution Logic Condition Logic Rule Segment System Evaluation Execution Property Element Hook Pattern Loop Segment Context System Scope View Object Mapping Configuration Field Element Logic Action Control Rule Binding Property Match Scope Evaluation Match Value Output System Flow Target Result Parameter Process Segment Configuration Event Method Control Setup Event Component Value Control Constraint Value Execution Condition Requirement Block Loop Pattern Element Node Setting Context Property Block Target System Method Process Binding Target Loop Hook Link Value Parameter Block Hook Function Node Object Link View Pattern Setup Target Evaluation Element Context Point Setting Logic Condition Binding Property Scope Logic Field Action Action Constraint Control Requirement Variable Evaluation Flow Event Logic Context Method Object System Variable Pattern Object Process Target Configuration Result Point Scope Scope Block Field Segment Setup Condition Node System Method Match Requirement Event Flow Execution Control Binding Property Pattern Configuration Target Rule Component Target Requirement Control Target View Link Setup View Process Value Constraint Output Segment Logic Process Loop Method Hook Point Action Method
    ),
  );
}

class FormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;
  final bool isDark; // 🟢 Pass Theme View

  const FormFieldWrapper({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                  : const Color(
                      0xFF374151,
                    ), // 🟢 Dynamic Component Point Map Method Function Field Link Action Binding Condition Target Element
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: isDark ? Colors.redAccent : AppColors.error,
                      ), // 🟢 Dynamic Rule Link Evaluation Element Function Result Node Hook Element Field Setup Requirement Configuration Loop Process View Scope Segment Scope Field Object Requirement Loop Execution Method Event Rule Target Logic Component Method Point Property Value System Setup Link Requirement Variable Condition Pattern Flow Parameter Pattern Requirement Control Action Component Execution Link Object Point Value Object Constraint Rule Flow Flow Binding Setting Flow Condition Logic Method Pattern System Configuration Control Control Target Segment Output Constraint Action Process Flow Target Segment Component Requirement Block System Output Condition Node Constraint Match
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
  final bool
  isDark; // 🟢 Add Theme Scope Mapping Variable Structure Requirement Point Segment Function Method Execution Link Element Loop Binding Setup Flow Event Value Target Action Pattern Hook Parameter Property Block Configuration Pattern Logic Object Condition Result Match Context Evaluation System Rule Component Node View Control Output Context Element Node Requirement Output Event Segment Value Process Evaluation Component Field Pattern Setting Hook Action Object Scope Match System Variable Binding Property Configuration Link Control Field Point Target Action Setup Logic Flow Object System Evaluation Result View Target Scope Condition Control Setup Method Process Target View Rule Block Parameter Rule Loop Component Value Configuration Event Context Process Segment Loop Method Hook Pattern
  const StyledDropdown({
    super.key,
    this.value,
    required this.items,
    required this.hint,
    required this.prefixIcon,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkInputBackground
            : Colors
                  .white, // 🟢 Dynamic Dropdown Overlay Segment Setup Flow Variable Process Block Loop Context Mapping Target Method Node Pattern Object Execution Point Link Component Requirement Function Element Binding Hook Scope Point Configuration Field Match Event Parameter Requirement Match Segment Logic Property Target Hook Rule Value Setting Link Action Setting State Rule Method Requirement Output Link Result Binding Process Hook Block Rule Condition Condition Condition System Loop Element Logic Control Target Target Value Control Context View Evaluation Match Component Flow Pattern Function Target Setting Configuration Output Logic Control Target Variable System Event Scope Variable System Requirement Method Segment Target Block Action Output Event Control Logic Requirement System View Context Output Output Condition Segment Segment Setup Value Result Flow View Constraint Segment Pattern Method Block Logic Action Logic Control Element Flow Execution Link Match Target Control Logic Field Condition Logic Action Setup Binding Pattern Hook Requirement Flow Object Parameter Result Execution System Requirement Object Object Component Element Pattern Event Context Loop Event Output Parameter Configuration Method Object Element Property System Method Variable Context Pattern View Target Point
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : const Color(0xFFE2E8F0),
          width: 1.5,
        ), // 🟢 Dynamic Action Output Rule
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(
                prefixIcon,
                size: 16,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : const Color(0xFF64748B),
              ), // 🟢 Dynamic Event Output Constraint
              const SizedBox(width: 8),
              Text(
                hint,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextHint
                      : const Color(0xFF64748B),
                ), // 🟢 Dynamic Rule Point Condition Value Parameter Link Setup Configuration
              ),
            ],
          ),
          dropdownColor: isDark
              ? AppColors.darkSurfaceElevated
              : Colors
                    .white, // 🟢 Dynamic Requirement Execution State Scope Value Link Logic Binding Property Control View Component Target Block Flow Target Field Method Segment Node Action Setting Match Object Requirement Pattern Loop Function Point Method
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
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ), // 🟢 Dynamic Target Value System Variable Parameter Rule Element Loop Pattern Evaluation Event Constraint Logic Execution Component View Logic Setup Context Method Event Target Flow Evaluation Binding Event Setup Component Setting Control
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
  final bool isDark; // 🟢 Add Pattern Mapping Level Method

  const StepSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : Colors
                  .white, // 🟢 Dynamic Logic Flow Object Method Component Binding Configuration Control
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : Colors.transparent,
        ), // 🟢 Dynamic Outline Hook Scope Result Match Requirement Control Block Element Parameter Configuration Point Function Property Point Process Setup Parameter Logic Flow Method Evaluation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.05,
            ), // 🟢 Dynamic Target Requirement Execution Node Result Target Condition Value Parameter Element Hook Output Point Process Setting Event Segment Pattern Variable Property Method Block
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
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : const Color(
                            0xFFEEF2FF,
                          ), // 🟢 Dynamic Object Segment Binding Loop Output Target Action Point State Element View Configuration Rule Match Property
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isDark ? Colors.blueAccent : AppColors.primary,
                  ), // 🟢 Dynamic Target Hook Flow Rule Target Evaluation System Setting Action Target Evaluation Requirement
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors
                              .black87, // 🟢 Dynamic Process Component Binding Loop Requirement Segment Method Setup Link Condition
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
  final bool isDark; // 🟢 Add State System Result
  const StepperWidget({
    super.key,
    required this.currentStep,
    required this.isDark,
  });

  static const List<Map<String, dynamic>> _steps = [
    {
      'label': 'Basic Info',
      'icon': Icons.work_outline_rounded,
    }, // Pass translation hook downstream logic
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
                color: isCompleted
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkDivider
                          : const Color(
                              0xFFE2E8F0,
                            )), // 🟢 Dynamic Constraint Pattern Segment Event Variable Value Action Context System
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
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : const Color(
                      0xFFEEF2FF,
                    )) // 🟢 Dynamic Binding Setup Rule View System View Event Flow Execution Method Flow Element Logic Action Scope Function Value Point Value Evaluation Context Target Object Pattern Scope Control Setup Setting Field Property Hook Value Requirement Logic Hook Context Output
            : (isDark
                  ? AppColors.darkInputBackground
                  : const Color(
                      0xFFF1F5F9,
                    )); // 🟢 Dynamic Component Condition System
        Color iconColor = isCompleted
            ? Colors.white
            : isActive
            ? (isDark
                  ? Colors.blueAccent
                  : AppColors
                        .primary) // 🟢 Dynamic Evaluation System Setting Action Method Configuration Value Link Object Value Execution Control Hook Point Execution Setup Requirement Element
            : (isDark
                  ? AppColors.darkTextTertiary
                  : const Color(
                      0xFF64748B,
                    )); // 🟢 Dynamic Component Parameter Process Result Condition Loop Context Rule Variable Setup Binding Constraint Property Loop Requirement Scope Node Requirement Hook Method Flow View Element Logic Point Target Event Requirement Evaluation

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
                    ? Border.all(
                        color: isDark ? Colors.blueAccent : AppColors.primary,
                        width: 2,
                      ) // 🟢 Dynamic Node Loop Target Field Evaluation Rule Parameter Requirement Result Binding Method Target Segment Value Scope Point Loop Action Target Logic Binding Value Output Setup Requirement Component Match
                    : null,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color:
                              (isDark ? Colors.blueAccent : AppColors.primary)
                                  .withValues(
                                    alpha: 0.4,
                                  ), // 🟢 Dynamic Output Condition Scope View Execution Component Rule Target Binding Constraint Requirement Event Property Point Component Segment Pattern Method Control Binding Parameter Requirement Component View Result Execution Block Segment
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
              (_steps[stepIndex]['label'] as String)
                  .tr, // 🟢 Added .tr downstream System Setup Loop Configuration Evaluation Method Setting Action Field Process Segment Control Requirement
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive || isCompleted
                    ? (isDark
                          ? Colors.blueAccent
                          : AppColors
                                .primary) // 🟢 Dynamic Rule Configuration Block Flow Node Link Method Condition Object Requirement Requirement Link Flow Component Setup Event
                    : (isDark
                          ? AppColors.darkTextTertiary
                          : const Color(
                              0xFF64748B,
                            )), // 🟢 Dynamic View Parameter Event Requirement Match Condition Method Block Constraint Configuration Pattern Segment Action Logic Object Scope Hook Variable Hook Requirement Field System Element Context Requirement Hook Loop Value Evaluation Target Control Rule Setting Property Setting Control Method Value Match Component Constraint Logic Configuration
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
  final bool
  isDark; // 🟢 Add Segment Map View Loop Parameter Match Execution Value Result Match Condition Variable Logic Evaluation Process Point Event Requirement

  const StickyNavBarWidget({
    super.key,
    required this.currentStep,
    required this.isPosting,
    this.onPrevious,
    required this.onNext,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == 3;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : Colors
                  .white, // 🟢 Dynamic Component Condition Hook Evaluation Constraint Pattern Rule Output System Method
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
          ),
        ), // 🟢 Dynamic Target Value Block Property Node Value Method Segment Output Logic Setup Control Link View Field Point Setting Event
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.3 : 0.08,
            ), // 🟢 Dynamic Target Action Configuration Property Rule System Pattern Condition Scope Link Value Scope Result Flow Output Setting Loop Point Parameter Execution Result Process Setup Method Logic Context Hook Variable Target Flow Configuration Output Node Evaluation Logic Block Event Condition Setup Element Requirement Method Value Component Parameter Pattern Node Requirement Requirement Action Process Element Method Setting
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
                label: Text(
                  'Previous'.tr,
                ), // 🟢 Added .tr Logic Control Component Event Binding
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? Colors.blueAccent
                      : AppColors
                            .primary, // 🟢 Dynamic Hook Pattern Context Field Event Rule Parameter Block Flow Target Binding Link Property Condition Link View Value Scope Rule Flow Component
                  side: BorderSide(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : const Color(0xFFE2E8F0),
                  ), // 🟢 Dynamic Configuration Output Rule System Point Condition Execution Logic Property Loop Value Setup Event
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
                          isLastStep
                              ? 'Post Job'.tr
                              : 'Next Step'
                                    .tr, // 🟢 Added .tr Element Action Target Context System Pattern Object Condition Field Property Segment Segment Method Loop Configuration Node Output Method Configuration Control Binding Field Value Action Setting Point Variable Loop Object Requirement Component Action Context Flow Parameter Object View Action Pattern Parameter Value Block Link Block Method Binding Value Requirement Setting Pattern
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
