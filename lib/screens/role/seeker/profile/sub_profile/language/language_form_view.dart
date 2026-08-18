import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/language/language_view.dart';

class LanguageFormView extends GetView<LanguageViewController> {
  const LanguageFormView({super.key});

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
                ? 'Add Language'
                      .tr // 🟢 Added .tr
                : 'Edit Language'.tr, // 🟢 Added .tr
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
            _buildLabel('Language *'.tr, theme), // 🟢 Added .tr
            _buildTextField(
              context,
              'e.g., English, Khmer, French'.tr, // 🟢 Added .tr
              ctrl: controller.languageNameCtrl,
            ),
            const SizedBox(height: 24),

            _buildLabel('Proficiency Level *'.tr, theme), // 🟢 Added .tr
            _buildDropdownField(
              context,
              'Select Level'.tr, // 🟢 Added .tr
              ctrl: controller.proficiencyCtrl,
            ),
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
                  : () => controller.saveLanguage(),
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
                          ? 'Save Language'
                                .tr // 🟢 Added .tr
                          : 'Update Language'.tr, // 🟢 Added .tr
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

  Widget _buildLabel(String text, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    ),
  );

  Widget _buildTextField(
    BuildContext context,
    String hint, {
    required TextEditingController ctrl,
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

  Widget _buildDropdownField(
    BuildContext context,
    String hint, {
    required TextEditingController ctrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> levels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Fluent / Native',
    ];
    String? currentValue = ctrl.text.isNotEmpty ? ctrl.text : null;

    if (currentValue != null && !levels.contains(currentValue)) {
      levels.add(currentValue);
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
      items: levels
          .map(
            (String level) => DropdownMenuItem<String>(
              value: level,
              child: Text(level.tr), // 🟢 Added .tr to translate dropdown item
            ),
          )
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) ctrl.text = newValue;
      },
    );
  }
}
