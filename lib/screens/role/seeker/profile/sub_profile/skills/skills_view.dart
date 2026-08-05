import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/seeker_profile_services.dart';
import 'package:jobber_city/models/role/seeker/seeker_profile_model.dart';
import 'package:jobber_city/screens/role/seeker/profile/profile_screen/profile_screen_view.dart';

part 'skills_binding.dart';
part 'skills_controller.dart';

class SkillsView extends GetView<SkillsViewController> {
  const SkillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Skills',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add your skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add skills that highlight your expertise.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // 🎯 ប្រអប់វាយបញ្ចូល
            TextField(
              controller: controller.skillInputCtrl,
              onSubmitted: (_) => controller
                  .addSkill(), // ពេលវាយចប់ចុច Enter លើ Keyboard ឲ្យ Add តែម្ដង
              decoration: InputDecoration(
                hintText: 'e.g., Flutter, Problem Solving...',
                filled: true,
                fillColor: Colors.grey.shade50,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  onPressed: () => controller.addSkill(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🎯 ផ្ទៃបង្ហាញជំនាញជា Chip
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.skillsList.map((skill) {
                      return Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide.none,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        onDeleted: () => controller.removeSkill(skill),
                      );
                    }).toList(),
                  ),
                ),
              ),
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
                  : () => controller.saveSkills(),
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
                  : const Text(
                      'Save Skills',
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
}
