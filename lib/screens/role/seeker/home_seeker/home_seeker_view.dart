import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Seeker'),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<AuthController>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }

              return Text(
                "សួស្តី, ${controller.firstName.value} ${controller.lastName.value} 🎉",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // controller.fetchProfileRaw();
                Get.toNamed(AppRoutes.jobDetail);
              },
              icon: const Icon(Icons.work_outline_rounded),
              label: const Text('Job Detail'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
