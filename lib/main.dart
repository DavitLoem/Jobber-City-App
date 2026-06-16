import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/routes/app_pages.dart';
import 'package:jobber_city/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.lightBackground),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      // home: const LoginScreen(),
    );
  }
}
