import 'package:flutter/services.dart';

class BulletListFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    // 🎯 ១. បើគាត់កំពុងលុបអក្សរ (Backspace) មិនបាច់ធ្វើអ្វីទេ ទុកឱ្យវាលុបធម្មតា
    if (newText.length < oldText.length) {
      return newValue;
    }

    // 🎯 ២. បើទើបតែវាយអក្សរដំបូងគេបង្អស់ នោះបន្ថែម '• ' ពីមុខ
    if (oldText.isEmpty && newText.isNotEmpty && !newText.startsWith('•')) {
      return TextEditingValue(
        text: '• $newText',
        selection: TextSelection.collapsed(offset: newText.length + 2),
      );
    }

    // 🎯 ៣. បើគាត់ចុច Enter ចុះបន្ទាត់ (\n) នោះបន្ថែម '• ' នៅបន្ទាត់ថ្មី
    if (newText.endsWith('\n') && !oldText.endsWith('\n')) {
      return TextEditingValue(
        text: '$newText• ',
        selection: TextSelection.collapsed(offset: newText.length + 2),
      );
    }

    return newValue;
  }
}
