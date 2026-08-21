import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/screens/role/seeker/profile/sub_profile/education/education_view.dart';

class EducationFormView extends GetView<EducationViewController> {
  const EducationFormView({super.key});

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
        // 🎯 ប្រើ Obx ដូរ Title
        title: Obx(
          () => Text(
            controller.editingId.value == null
                ? 'Add Education'
                : 'Edit Education',
            style: const TextStyle(
              color: Colors.black87,
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
            _buildLabel('School / University Name *'),
            _buildTextField(
              'e.g., Norton University',
              ctrl: controller.schoolNameCtrl,
            ),
            const SizedBox(height: 16),

            _buildLabel('Degree *'),
            _buildDropdownField('Select Degree', ctrl: controller.degreeCtrl),
            const SizedBox(height: 16),

            _buildLabel('Field of Study'),
            _buildTextField(
              'e.g., Computer Science',
              ctrl: controller.fieldOfStudyCtrl,
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
                        'YYYY-MM-DD',
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
                      _buildLabel('End Date (Optional)'),
                      _buildDateField(
                        context,
                        'YYYY-MM-DD',
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
              // 🎯 Disable button ពេលកំពុង Save
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.saveEducation(),
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
                          ? 'Save Education'
                          : 'Update Education',
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

  // ─── Reusable Helper Methods ───
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

  // 🎯 មុខងារថ្មីសម្រាប់ Dropdown Degree
  Widget _buildDropdownField(
    String hint, {
    required TextEditingController ctrl,
  }) {
    // បញ្ជីសញ្ញាបត្រទូទៅ
    final List<String> degrees = [
      'High School Diploma',
      'Associate\'s Degree',
      'Bachelor\'s Degree',
      'Master\'s Degree',
      'Doctorate (PhD)',
      'Other',
    ];

    // ត្រួតពិនិត្យក្រែងលោទិន្នន័យចាស់ (ពេល Edit) អត់មានក្នុង List ខាងលើ
    String? currentValue = ctrl.text.isNotEmpty ? ctrl.text : null;
    if (currentValue != null && !degrees.contains(currentValue)) {
      degrees.add(
        currentValue,
      ); // បន្ថែមចូល List បណ្តោះអាសន្ន ដើម្បីកុំឱ្យ Error
    }

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey.shade600,
      ),
      items: degrees.map((String degree) {
        return DropdownMenuItem<String>(value: degree, child: Text(degree));
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          ctrl.text = newValue; // ភ្ជាប់តម្លៃដែលរើសបានទៅកាន់ Controller ដើម
        }
      },
    );
  }

  // 🎯 បន្ថែម Parameter TextEditingController
  Widget _buildTextField(
    String hint, {
    IconData? icon,
    TextEditingController? ctrl,
  }) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        suffixIcon: icon != null
            ? Icon(icon, color: Colors.grey.shade500, size: 20)
            : null,
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

  // 🎯 Date Picker Function
  Widget _buildDateField(
    BuildContext context,
    String hint, {
    required TextEditingController ctrl,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: true,
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
