import 'dart:async';

import 'package:flutter/foundation.dart';

// ឧបករណ៍ជំនួយសម្រាប់ពន្យារពេល
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    // បើមាន Timer ចាស់កំពុងរាប់ គឺត្រូវលុបចោលវិញសិន
    _timer?.cancel();
    // ចាប់ផ្តើមរាប់ថ្មី បើវាយអក្សរចប់ក្នុងរយៈពេលកំណត់ ទើបអនុញ្ញាតឱ្យដើរ Action នេះ
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
