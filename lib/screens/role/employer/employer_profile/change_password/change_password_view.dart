import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'change_password_binding.dart';
part 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordViewController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── សារណែនាំ (Instruction) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8EEFF)),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.info,
                    color: Color(0xFF4f7df7),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your new password must be at least 8 characters long and include a mix of letters and numbers.",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Form បញ្ចូលពាក្យសម្ងាត់ ──
            _buildPasswordField(
              label: "Current Password",
              hint: "Enter your current password",
              isObscured: obscureCurrent,
              onToggleVisibility: () {
                //setState(() => obscureCurrent = !obscureCurrent);
              },
            ),
            const SizedBox(height: 20),

            const Divider(color: Color(0xFFEEEEEE), thickness: 1),
            const SizedBox(height: 20),

            _buildPasswordField(
              label: "New Password",
              hint: "Enter your new password",
              isObscured: obscureNew,
              onToggleVisibility: () {
                //setState(() => obscureNew = !obscureNew);
              },
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              label: "Confirm New Password",
              hint: "Re-enter your new password",
              isObscured: obscureConfirm,
              onToggleVisibility: () {
                //setState(() => obscureConfirm = !obscureConfirm);
              },
            ),

            const SizedBox(height: 40),

            // ── ប៊ូតុង Update Password ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // មុខងារហៅ API សម្រាប់ដូរ Password
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4f7df7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ── មុខងារជំនួយ (Helper Widget) ──
  // ==========================================
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isObscured,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            prefixIcon: Icon(
              LucideIcons.lock,
              color: Colors.grey.shade400,
              size: 20,
            ),
            // ប៊ូតុងភ្នែកសម្រាប់មើល/លាក់
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? LucideIcons.eyeOff : LucideIcons.eye,
                color: Colors.grey.shade500,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
              borderSide: const BorderSide(
                color: Color(0xFF4f7df7),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
