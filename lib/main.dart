import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 🟢 Added Storage Import
import 'package:get/get.dart';
import 'package:jobber_city/bindings/initial_binding.dart';
import 'package:jobber_city/core/theme/app_theme.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
import 'package:jobber_city/firebase_options.dart';
import 'package:jobber_city/routes/app_pages.dart';
import 'package:jobber_city/routes/app_routes.dart';

import 'package:jobber_city/widgets/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(ThemeController(), permanent: true);

  // 🟢 Load Saved Language Preference
  const storage = FlutterSecureStorage();
  String? langCode = await storage.read(key: 'app_lang');
  String? countryCode = await storage.read(key: 'app_country');

  // Default to device locale if nothing is saved
  Locale initialLocale = Get.deviceLocale ?? const Locale('en', 'US');
  if (langCode != null && countryCode != null) {
    initialLocale = Locale(langCode, countryCode);
  }

  // 🟢 Pass the loaded locale into MyApp
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale; // 🟢 Accept the initial locale

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode.value,

      translations: AppTranslations(),
      locale:
          initialLocale, // 🟢 Use the loaded locale instead of forcing device locale
      fallbackLocale: const Locale('en', 'US'),

      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
