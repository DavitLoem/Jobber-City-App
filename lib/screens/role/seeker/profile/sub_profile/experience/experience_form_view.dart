import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/experience/experience_view.dart';

class ExperienceFormView extends GetView<ExperienceViewController> {
  const ExperienceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.editingId.value == null
                ? 'Add Experience'
                      .tr // 🟢 Added .tr
                : 'Edit Experience'.tr, // 🟢 Added .tr
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Job Title *'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              hint: 'e.g., Software Engineer'.tr, // 🟢 Added .tr
              ctrl: controller.jobTitleCtrl,
            ),
            const SizedBox(height: 16),

            _buildLabel('Company Name *'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              hint: 'e.g., Tech Corp Ltd.'.tr, // 🟢 Added .tr
              ctrl: controller.companyNameCtrl,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Date *'.tr, theme), // 🟢 Added .tr
                      _buildDateField(
                        context,
                        hint: 'Select date'.tr, // 🟢 Added .tr
                        ctrl: controller.startDateCtrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('End Date'.tr, theme), // 🟢 Added .tr
                      Obx(
                        () => controller.isCurrentJob.value
                            ? _buildTextField(
                                context,
                                hint: 'Present'.tr, // 🟢 Added .tr
                                enabled: false,
                              )
                            : _buildDateField(
                                context,
                                hint: 'Select date'.tr, // 🟢 Added .tr
                                ctrl: controller.endDateCtrl,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🎯 Checkbox
            Obx(
              () => Row(
                children: [
                  Checkbox(
                    value: controller.isCurrentJob.value,
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkCheckboxBorder
                          : AppColors.checkboxBorder,
                    ),
                    onChanged: (val) {
                      controller.isCurrentJob.value = val ?? false;
                      if (val == true) controller.endDateCtrl.clear();
                    },
                  ),
                  Text(
                    'I currently work here'.tr, // 🟢 Added .tr
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel('Description'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              hint: 'Describe your responsibilities...'.tr, // 🟢 Added .tr
              ctrl: controller.descriptionCtrl,
              maxLines: 4,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.saveExperience(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceElevated
                    : Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: controller.isSaving.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      controller.editingId.value == null
                          ? 'Add Experience'
                                .tr // 🟢 Added .tr
                          : 'Update Experience'.tr, // 🟢 Added .tr
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
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String hint,
    TextEditingController? ctrl,
    int maxLines = 1,
    bool enabled = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      enabled: enabled,
      style: TextStyle(
        color: enabled
            ? (isDark ? AppColors.darkInputText : AppColors.inputText)
            : (isDark ? AppColors.darkTextDisabled : AppColors.textDisabled),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          fontSize: 14,
        ),
        filled: true,
        fillColor: enabled
            ? (isDark
                  ? AppColors.darkInputBackground
                  : AppColors.inputBackground)
            : (isDark
                  ? AppColors.darkInputBackground.withValues(
                      alpha: 0.5,
                    ) // 🟢 Updated
                  : AppColors.inputDisabledBackground),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.primary : AppColors.inputFocusedBorder,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String hint,
    required TextEditingController ctrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: ctrl,
      readOnly: true,
      style: TextStyle(
        color: isDark ? AppColors.darkInputText : AppColors.inputText,
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
        );
        if (pickedDate != null) {
          ctrl.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          fontSize: 14,
        ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: isDark ? AppColors.darkIconSecondary : AppColors.iconSecondary,
          size: 20,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.darkInputBackground
            : AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.primary : AppColors.inputFocusedBorder,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
