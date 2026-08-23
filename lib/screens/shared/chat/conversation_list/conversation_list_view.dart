import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🎯 បន្ថែម Search Bar
          ConversationSearchBar(controller: controller.searchController),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.conversations.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4F7DF7)),
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
                color: const Color(0xFF4F7DF7),
                onRefresh: () => controller.fetchConversations(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: displayList.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 82,
                    color: Color(0xFFEEEEEE),
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
          backgroundColor: const Color(0xFF4F7DF7),
          onPressed: () async {
            // លោតទៅកាន់អេក្រង់ Seeker Directory
            // await Get.toNamed(AppRoutes.seekerDirectory);
            // ពេលត្រឡប់មកវិញ Refresh ទិន្នន័យដោយស្ងាត់ៗ
            controller.fetchConversations(silent: true);
          },
          icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
          label: const Text(
            'New Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        );
      }),
    );
  }
}
