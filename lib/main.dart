import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:jobber_city/bindings/initial_binding.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/theme/theme_controller.dart';
import 'package:jobber_city/firebase_options.dart';

import 'core/api/services/firebase_messaging_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'widgets/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 FIXED: Combined into a single Firebase initialization with options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🟢 ៣. ចុះឈ្មោះ Background Handler នៅទីនេះតែម្តង (នៅក្រៅ runApp)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,

        // 🟢 1. THEME CONFIGURATION
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.lightBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightBackground,
          ),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor:
              AppColors.darkBackground, // Ensure this exists in AppColors
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkBackground,
          ),
          cardColor: AppColors.darkSurfaceElevated ?? const Color(0xFF1E1E1E),
          textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
        ),
        themeMode: themeController.themeMode.value,
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),

        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
        // home: ChatsMainView(),
        // builder: (context, child) {
        //   return SafeArea(
        //     // ការពារកុំឱ្យចូលកាមេរ៉ាខាងលើ គ្រប់ Screen
        //     top: true,
        //     // អាចកំណត់ bottom: false បើចង់ឱ្យ Bottom Navigation ជាប់បាតស្អាត
        //     bottom: false,
        //     child: child!,
        //   );
        // },
      ),
    );
  }
}
