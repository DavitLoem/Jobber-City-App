import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Added AppColors
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/models/chat_model.dart';
import 'package:jobber_city/routes/app_routes.dart';

import 'widgets/conversation_list_widgets.dart';

part 'conversation_list_binding.dart';
part 'conversation_list_controller.dart';

class ConversationListView extends GetView<ConversationListViewController> {
  const ConversationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8F9FA), // 🟢 Dynamic BG
      body: Column(
        children: [
          // 🎯 បន្ថែម Search Bar
          ConversationSearchBar(controller: controller.searchController),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.conversations.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ), // 🟢 Replaced Hex with AppColors
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.conversations.isEmpty) {
                return ConversationErrorState(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchConversations(),
                );
              }

              // 🎯 ប្រើ filteredConversations ជំនួស conversations
              final displayList = controller.filteredConversations;

              if (displayList.isEmpty) {
                return ConversationEmptyState(
                  isSearching: controller.searchController.text
                      .trim()
                      .isNotEmpty,
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => controller.fetchConversations(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: displayList.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: 82,
                    color: isDark
                        ? AppColors.darkDivider
                        : const Color(0xFFEEEEEE), // 🟢 Dynamic Divider
                  ),
                  itemBuilder: (context, index) {
                    final convo = displayList[index];
                    return ConversationTile(
                      conversation: convo,
                      onTap: () => controller.openConversation(convo),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      // 🎯 បន្ថែម Floating Action Button សម្រាប់តែ Employer ប៉ុណ្ណោះ
      floatingActionButton: Obx(() {
        if (!controller.isEmployer.value) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          backgroundColor: AppColors.primary, // 🟢 Replaced Hex
          onPressed: () async {
            // លោតទៅកាន់អេក្រង់ Seeker Directory
            // await Get.toNamed(AppRoutes.seekerDirectory);
            // ពេលត្រឡប់មកវិញ Refresh ទិន្នន័យដោយស្ងាត់ៗ
            controller.fetchConversations(silent: true);
          },
          icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
          label: Text(
            'New Chat'.tr, // 🟢 Added .tr
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }),
    );
  }
}
