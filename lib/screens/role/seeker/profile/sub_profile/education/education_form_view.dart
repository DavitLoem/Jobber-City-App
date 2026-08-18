import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/education/education_view.dart';

class EducationFormView extends GetView<EducationViewController> {
  const EducationFormView({super.key});

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
                ? 'Add Education'
                      .tr // 🟢 Added .tr
                : 'Edit Education'.tr, // 🟢 Added .tr
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
            _buildLabel('School / University Name *'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              'e.g., Norton University'.tr, // 🟢 Added .tr
              ctrl: controller.schoolNameCtrl,
            ),
            const SizedBox(height: 16),

            _buildLabel('Degree *'.tr, theme), // 🟢 Added .tr
            _buildDropdownField(
              context,
              'Select Degree'.tr, // 🟢 Added .tr
              ctrl: controller.degreeCtrl,
            ),
            const SizedBox(height: 16),

            _buildLabel('Field of Study'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              'e.g., Computer Science'.tr, // 🟢 Added .tr
              ctrl: controller.fieldOfStudyCtrl,
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
                        'YYYY-MM-DD'.tr, // 🟢 Added .tr
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
                      _buildLabel(
                        'End Date (Optional)'.tr,
                        theme,
                      ), // 🟢 Added .tr
                      _buildDateField(
                        context,
                        'YYYY-MM-DD'.tr, // 🟢 Added .tr
                        ctrl: controller.endDateCtrl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                  : () => controller.saveEducation(),
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
                          ? 'Save Education'
                                .tr // 🟢 Added .tr
                          : 'Update Education'.tr, // 🟢 Added .tr
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

  Widget _buildDropdownField(
    BuildContext context,
    String hint, {
    required TextEditingController ctrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> degrees = [
      'High School Diploma',
      'Associate\'s Degree',
      'Bachelor\'s Degree',
      'Master\'s Degree',
      'Doctorate (PhD)',
      'Other',
    ];

    String? currentValue = ctrl.text.isNotEmpty ? ctrl.text : null;
    if (currentValue != null && !degrees.contains(currentValue)) {
      degrees.add(currentValue);
    }

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      dropdownColor: Theme.of(context).cardColor,
      style: TextStyle(
        fontSize: 16,
        color: isDark ? AppColors.darkInputText : AppColors.inputText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          fontSize: 14,
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
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? AppColors.darkIconSecondary : AppColors.iconSecondary,
      ),
      items: degrees.map((String degree) {
        return DropdownMenuItem<String>(
          value: degree,
          child: Text(degree.tr), // 🟢 Added .tr to translate dropdown items
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          ctrl.text = newValue;
        }
      },
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String hint, {
    IconData? icon,
    TextEditingController? ctrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: ctrl,
      style: TextStyle(
        color: isDark ? AppColors.darkInputText : AppColors.inputText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          fontSize: 14,
        ),
        suffixIcon: icon != null
            ? Icon(
                icon,
                color: isDark
                    ? AppColors.darkIconSecondary
                    : AppColors.iconSecondary,
                size: 20,
              )
            : null,
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

  Widget _buildDateField(
    BuildContext context,
    String hint, {
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
