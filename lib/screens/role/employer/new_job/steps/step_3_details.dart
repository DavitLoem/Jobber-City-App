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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Job Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Provide specific requirements and benefits",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // ── 1. Education Level (ប្រើ Single Select ដូច Step 1) ──
            CustomFormTextField(
              label: "Education Level *",
              hint: "e.g. Bachelor's Degree",
              isDropdown: true,
              controller: controller.educationLevelCtrl,
              onTap: () async {
                final educations = await controller.masterDataCtrl
                    .getMasterData(endpoint: 'education-levels');

                CustomBottomSheetPicker.show<MasterDataModel>(
                  title: "Select Education Level",
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
              label: "Experience *",
              hint: "e.g. 1 Year, 2-3 Years, No experience",
              controller: controller.experienceCtrl,
            ),
            const SizedBox(height: 16),

            // ── 2. Required Skills (Multi-Select ពី Master Data) ──
            CustomFormTextField(
              label: "Required Skills *",
              hint: "Tap to select skills",
              isDropdown: true,
              controller: controller.requiredSkillsTextCtrl,
              onTap: () async {
                // ទាញយក Skills ពី Master Data
                final skills = await controller.masterDataCtrl.getMasterData(
                  endpoint: 'skills',
                );

                CustomMultiSelectBottomSheet.show<MasterDataModel>(
                  title: "Select Required Skills",
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

            // បង្ហាញ Chips ពណ៌ខៀវខាងក្រោមប្រអប់ ពេលគាត់រើសរួចរាល់
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
                            backgroundColor: Colors.blueAccent,
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                            onDeleted: () {
                              // មុខងារចុចខ្វែងលុប
                              final index = controller.selectedSkillNames
                                  .indexOf(skill);
                              controller.selectedSkillNames.removeAt(index);
                              controller.selectedSkillIds.removeAt(index);

                              // 🎯 ត្រូវថែមបន្ទាត់នេះ! ដើម្បី Update អក្សរក្នុងប្រអប់វិញ
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

            // ── 3. Custom Skills (បញ្ចូលដោយសេរី) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomFormTextField(
                    label: "Other Custom Skills (Optional)",
                    hint: "e.g. Figma",
                    controller: controller.customSkillsCtrl,
                  ),
                ),
                const SizedBox(width: 8),

                // ប៊ូតុងសម្រាប់ចុច Add បញ្ចូល Skill
                ElevatedButton(
                  onPressed: controller.addCustomSkill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // បង្ហាញ Chips សម្រាប់ Custom Skills ខាងក្រោមប្រអប់
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
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            // ប្រើពណ៌ប្រផេះស្រាល ដើម្បីងាយស្រួលចំណាំខុសពី Required Skills ពណ៌ខៀវ
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black54,
                            ),
                            onDeleted: () {
                              // មុខងារចុចខ្វែងលុប
                              controller.customSkillsList.remove(skill);
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            // ── 4. Job Description ──
            CustomFormTextField(
              label: "Job Description *",
              hint: "Describe the day-to-day responsibilities...",
              maxLines: 4,
              controller: controller.descriptionCtrl,
              inputFormatters: [BulletListFormatter()],
            ),
            const SizedBox(height: 16),

            // ── 5. Requirements ──
            CustomFormTextField(
              label: "Requirements *",
              hint: "List the required qualifications, experience...",
              maxLines: 4,
              controller: controller.requirementsCtrl,
              inputFormatters: [BulletListFormatter()],
            ),
            const SizedBox(height: 16),

            // ── 6. Benefits ──
            CustomFormTextField(
              label: "Benefits",
              hint: "List what you offer (e.g. Insurance, Annual Leave...)",
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
