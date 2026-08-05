import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/experience/experience_view.dart'; // កុំភ្លេច add intl package (flutter pub add intl)

// 🎯 ប្តូរទៅជា GetView
class ExperienceFormView extends GetView<ExperienceViewController> {
  const ExperienceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.editingId.value == null
              ? 'Add Experience'
              : 'Edit Experience',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Job Title *'),
            _buildTextField(
              hint: 'e.g., Software Engineer',
              ctrl: controller.jobTitleCtrl,
            ),
            const SizedBox(height: 16),

            _buildLabel('Company Name *'),
            _buildTextField(
              hint: 'e.g., Tech Corp Ltd.',
              ctrl: controller.companyNameCtrl,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Date *'),
                      _buildDateField(
                        context,
                        hint: 'Select date',
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
                      _buildLabel('End Date'),
                      // 🎯 លាក់ប្រអប់ End Date ប្រសិនបើគាត់ចុច Current Job
                      Obx(
                        () => controller.isCurrentJob.value
                            ? _buildTextField(hint: 'Present', enabled: false)
                            : _buildDateField(
                                context,
                                hint: 'Select date',
                                ctrl: controller.endDateCtrl,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🎯 Checkbox ភ្ជាប់ជាមួយ State
            Obx(
              () => Row(
                children: [
                  Checkbox(
                    value: controller.isCurrentJob.value,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      controller.isCurrentJob.value = val ?? false;
                      if (val == true) controller.endDateCtrl.clear();
                    },
                  ),
                  const Text(
                    'I currently work here',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel('Description'),
            _buildTextField(
              hint: 'Describe your responsibilities...',
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
              // 🎯 ហាមចុចប្រសិនបើកំពុង Save
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.saveExperience(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
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
                          : 'Update Experience',
                      style: TextStyle(
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 🎯 បន្ថែម Parameter TextEditingController
  Widget _buildTextField({
    required String hint,
    TextEditingController? ctrl,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: enabled
            ? Colors.grey.shade50
            : Colors.grey.shade200, // ដូរពណ៌បន្តិចបើវា disabled
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  // 🎯 មុខងារថ្មីសម្រាប់រើសថ្ងៃខែ (DatePicker)
  Widget _buildDateField(
    BuildContext context, {
    required String hint,
    required TextEditingController ctrl,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: true, // មិនឱ្យវាយបញ្ចូលផ្ទាល់
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now().add(
            const Duration(days: 3650),
          ), // អនុញ្ញាតឱ្យរើសដល់អនាគត (សម្រាប់ End Date)
        );
        if (pickedDate != null) {
          // Format ទៅជា "YYYY-MM-DD" ឱ្យត្រូវនឹងទម្រង់ Backend
          ctrl.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.grey.shade500,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
