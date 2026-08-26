import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations
import 'package:jobber_city/screens/role/seeker/profile/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import 'section_field_label.dart';

class ContactSection extends StatelessWidget {
  final EditProfileScreenViewController controller;
  const ContactSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionFieldLabel(title: 'Email'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.email_outlined,
          hintText: 'Email'.tr, // 🟢 Added .tr
          controller: controller.emailCtrl,
          readOnly: true,
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(title: 'Phone'.tr), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.phone_outlined,
          hintText: 'Phone Number'.tr, // 🟢 Added .tr
          controller: controller.phoneCtrl,
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(
          title: 'Portfolio URL'.tr,
          isOptional: true,
        ), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.public_outlined,
          hintText: 'Portfolio URL'.tr, // 🟢 Added .tr
          controller: controller.portfolioCtrl,
        ),
        const SizedBox(height: 20),

        SectionFieldLabel(
          title: 'LinkedIn URL'.tr,
          isOptional: true,
        ), // 🟢 Added .tr
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.link_outlined,
          hintText: 'LinkedIn URL'.tr, // 🟢 Added .tr
          controller: controller.linkedinCtrl,
        ),
      ],
    );
  }
}
