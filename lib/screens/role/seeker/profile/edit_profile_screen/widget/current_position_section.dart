import 'package:flutter/material.dart';
import 'package:jobber_city/screens/role/seeker/profile/widget/profile_text_field.dart';

import '../edit_profile_screen_controller.dart';
import 'section_field_label.dart';

class CurrentPositionSection extends StatelessWidget {
  final EditProfileScreenViewController controller;
  const CurrentPositionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionFieldLabel(title: 'Current Position', isOptional: true),
        const SizedBox(height: 6),
        ProfileTextField(
          prefixIcon: Icons.work_outline,
          hintText: 'Enter your current position',
          controller: controller.currentPositionCtrl,
        ),
      ],
    );
  }
}
