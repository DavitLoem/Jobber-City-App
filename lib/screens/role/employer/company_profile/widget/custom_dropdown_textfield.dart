import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class CustomDropdownTextfield extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onChanged;

  CustomDropdownTextfield({
    super.key,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,

      // 🟢 ១. នេះជាពណ៌សម្រាប់អក្សរដែលបានជ្រើសរើសរួច (Selected Value)
      style: const TextStyle(
        color: AppColors.inputText, // ពណ៌ខ្មៅ ឬពណ៌ដែលអ្នកចង់បាន
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      // 🟢 ២. ប្រើ `hint` នៅទីនេះផ្ទាល់ ដើម្បីកំណត់ពណ៌ Hint ដាច់ដោយឡែក (មិនឱ្យជាន់គ្នាជាមួយ style លើ)
      hint: Text(
        hint,
        style: const TextStyle(
          color: Colors.grey, // ពណ៌ប្រផេះសម្រាប់ Hint
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.inputIconText,
        size: 26,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      menuMaxHeight: 350,

      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBackground,

        // 🟢 ៣. លុប hintText និង hintStyle ចេញពីទីនេះ ព្រោះយើងបានប្រើវានៅខាងលើរួចហើយ
        prefixIcon: Icon(icon, color: AppColors.inputIconText),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
