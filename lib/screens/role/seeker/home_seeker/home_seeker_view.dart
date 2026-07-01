import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/auth_controller.dart';
import 'package:jobber_city/core/api/services/auth_services.dart';
import 'package:jobber_city/core/utils/app_logger.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

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
        // ប្រើ Column ដើម្បីដាក់អក្សរនៅខាងលើ ហើយប៊ូតុងនៅខាងក្រោម
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // រុញអ្វីៗទាំងអស់ឱ្យនៅកណ្តាលអេក្រង់
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

            const SizedBox(height: 30), // ចន្លោះចំហរវាងអក្សរ និងប៊ូតុង
            // 🎯 ប៊ូតុងសម្រាប់ធ្វើតេស្ត Get Profile ថ្មី
            ElevatedButton.icon(
              onPressed: () {
                // ហៅមុខងារទាញយកទិន្នន័យម្តងទៀត ពេលគាត់ចុច
                controller.fetchProfileRaw();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Get Profile (Test Token)'),
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
