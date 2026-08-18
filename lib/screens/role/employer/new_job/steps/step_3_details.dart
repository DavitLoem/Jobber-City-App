import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/master_data_model.dart';
import 'package:jobber_city/screens/role/employer/new_job/new_job_view.dart';
import 'package:jobber_city/widgets/bullet_list_formatter.dart';
import 'package:jobber_city/widgets/custom_bottom_sheet_picker.dart';
import 'package:jobber_city/widgets/custom_form_textfield.dart';
import 'package:jobber_city/widgets/custom_multi_select_bottom_sheet.dart';

class Step3Details extends GetView<NewJobViewController> {
  const Step3Details({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Job Details".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Provide specific requirements and benefits".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            CustomFormTextField(
              label: "Education Level *".tr, // 🟢 Added .tr
              hint: "e.g. Bachelor's Degree".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.educationLevelCtrl,
              onTap: () async {
                final educations = await controller.masterDataCtrl
                    .getMasterData(endpoint: 'education-levels');
                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Education Level".tr, // 🟢 Added .tr
                  items: educations,
                  getName: (item) => item.name,
                  onSelected: (item) {
                    controller.educationLevelCtrl.text = item.name;
                    controller.selectedEducationLevelId.value = item.id;
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Experience *".tr, // 🟢 Added .tr
              hint: "e.g. 1 Year, 2-3 Years, No experience".tr, // 🟢 Added .tr
              controller: controller.experienceCtrl,
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Required Skills *".tr, // 🟢 Added .tr
              hint: "Tap to select skills".tr, // 🟢 Added .tr
              isDropdown: true,
              controller: controller.requiredSkillsTextCtrl,
              onTap: () async {
                final skills = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'skills',
                );
                CustomMultiSelectBottomSheet.show<MasterDataModel>(
                  title: "Select Required Skills".tr, // 🟢 Added .tr
                  items: skills,
                  initialSelectedIds: controller.selectedSkillIds.toList(),
                  getName: (item) => item.name,
                  getId: (item) => item.id,
                  onApply: (selectedItems) {
                    controller.selectedSkillIds.assignAll(
                      selectedItems.map((e) => e.id).toList(),
                    );
                    controller.selectedSkillNames.assignAll(
                      selectedItems.map((e) => e.name).toList(),
                    );
                    controller.requiredSkillsTextCtrl.text = controller
                        .selectedSkillNames
                        .join(", ");
                  },
                );
              },
            ),

            Obx(
              () => controller.selectedSkillNames.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.selectedSkillNames.map((skill) {
                          return Chip(
                            label: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: isDark
                                ? AppColors.primary.withValues(
                                    alpha: 0.8,
                                  ) // 🟢 Updated opacity
                                : Colors.blueAccent,
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                            onDeleted: () {
                              final index = controller.selectedSkillNames
                                  .indexOf(skill);
                              controller.selectedSkillNames.removeAt(index);
                              controller.selectedSkillIds.removeAt(index);
                              controller.requiredSkillsTextCtrl.text =
                                  controller.selectedSkillNames.join(", ");
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Other Custom Skills (Optional)".tr, // 🟢 Added .tr
                    hint: "e.g. Figma".tr, // 🟢 Added .tr
                    controller: controller.customSkillsCtrl,
                  ),
                ),
                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: controller.addCustomSkill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add".tr, // 🟢 Added .tr
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Obx(
              () => controller.customSkillsList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.customSkillsList.map((skill) {
                          return Chip(
                            label: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            backgroundColor: isDark
                                ? AppColors.darkSurfaceElevated
                                : Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.darkCardBorder
                                    : Colors.grey.shade300,
                              ),
                            ),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : Colors.black54,
                            ),
                            onDeleted: () {
                              controller.customSkillsList.remove(skill);
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Job Description *".tr, // 🟢 Added .tr
              hint: "Describe the day-to-day responsibilities..."
                  .tr, // 🟢 Added .tr
              maxLines: 4,
              controller: controller.descriptionCtrl,
              inputFormatters: [BulletListFormatter()],
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Requirements *".tr, // 🟢 Added .tr
              hint: "List the required qualifications, experience..."
                  .tr, // 🟢 Added .tr
              maxLines: 4,
              controller: controller.requirementsCtrl,
              inputFormatters: [BulletListFormatter()],
            ),
            const SizedBox(height: 16),

            CustomFormTextField(
              label: "Benefits".tr, // 🟢 Added .tr
              hint: "List what you offer (e.g. Insurance, Annual Leave...)"
                  .tr, // 🟢 Added .tr
              maxLines: 4,
              controller: controller.benefitsCtrl,
              inputFormatters: [BulletListFormatter()],
            ),
          ],
        ),
      ),
    );
  }
}
