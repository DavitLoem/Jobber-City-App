import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/screens/role/seeker/search_button/widgets/active_filter_chips.dart';

import 'search_button_controller.dart';
import 'widgets/search_header.dart';
import 'widgets/search_results.dart';
import 'widgets/search_suggestions.dart';

class SearchButtonView extends GetView<SearchButtonViewController> {
  const SearchButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 🟢 Header (មានប្រអប់ស្វែងរក)
            SearchHeader(topInset: topInset),

            // 🟢 របារ Filter Chips (វាលាក់ខ្លួនឯងបើអត់មាន Filter)
            const ActiveFilterChips(),

            // 🟢 Content
            Expanded(
              child: Obx(() {
                // 🎯 បន្ថែមលក្ខខណ្ឌ៖ បើគ្មានទាំងអក្សរ និងគ្មានទាំង Filter ទើបបង្ហាញទំព័រ Welcome
                if (controller.searchQuery.value.isEmpty &&
                    controller.activeFiltersCount.value == 0) {
                  return const SearchSuggestions();
                }
                return const SearchResults();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
