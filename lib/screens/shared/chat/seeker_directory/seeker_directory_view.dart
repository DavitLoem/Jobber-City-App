import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:jobber_city/core/api/services/chat/chat_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/core/utils/debouncer.dart';
import 'package:jobber_city/models/chat/chat_models.dart';
import 'package:jobber_city/routes/app_routes.dart';

part 'seeker_directory_controller.dart';

/// Employer-only "start a new chat" screen — browses EVERY seeker account in
/// the system (not just ones who applied to a job or already have a thread
/// open). Reached from a "New Chat" button on [ChatListView]. Tapping a row
/// calls `startConversation()` and opens the thread exactly like the
/// candidate-detail "Message" button already does.
class SeekerDirectoryView extends GetView<SeekerDirectoryController> {
  const SeekerDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'New Chat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.seekers.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (controller.errorMessage.value.isNotEmpty && controller.seekers.isEmpty) {
                return _ErrorState(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchSeekers(),
                );
              }

              if (controller.seekers.isEmpty) {
                return _EmptyState(isSearching: controller.searchController.text.trim().isNotEmpty);
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => controller.fetchSeekers(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.seekers.length + (controller.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 82, color: AppColors.divider),
                    itemBuilder: (context, index) {
                      if (index >= controller.seekers.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
                            ),
                          ),
                        );
                      }
                      final seeker = controller.seekers[index];
                      return _SeekerTile(
                        seeker: seeker,
                        isStarting: controller.startingChatWith.value == seeker.seekerUserId,
                        onTap: () => controller.startChatWith(seeker),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search seekers by name',
          hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 22),
          filled: true,
          fillColor: AppColors.lightSurfaceVariant,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _SeekerTile extends StatelessWidget {
  final SeekerDirectoryItem seeker;
  final bool isStarting;
  final VoidCallback onTap;
  const _SeekerTile({required this.seeker, required this.isStarting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isStarting ? null : onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _Avatar(name: seeker.fullName, avatarUrl: seeker.profileImageUrl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seeker.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    seeker.currentPosition?.isNotEmpty == true
                        ? seeker.currentPosition!
                        : (seeker.hasAppliedToYou ? 'Applied to your job' : 'Job seeker'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            if (seeker.hasAppliedToYou)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Applicant',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            const SizedBox(width: 10),
            isStarting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  const _Avatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
      clipBehavior: Clip.hardEdge,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? Image.network(avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback())
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSearching;
  const _EmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Icon(
                isSearching ? Icons.search_off_rounded : Icons.people_outline_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching ? 'No seekers match your search' : 'No seekers yet',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try a different name.'
                  : 'When candidates create an account, they will show up here so you can message them.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: AppColors.textTertiary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.textTertiary, size: 40),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textTertiary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
