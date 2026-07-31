import 'package:flutter/material.dart';
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
        const SectionFieldLabel(title: 'Email'),
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.email_outlined,
          hintText: 'Email',
          controller: controller.emailCtrl,
          readOnly: true,
        ),
        const SizedBox(height: 20),

        const SectionFieldLabel(title: 'Phone'),
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.phone_outlined,
          hintText: 'Phone Number',
          controller: controller.phoneCtrl,
        ),
      ],
    );
  }
}
