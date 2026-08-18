import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final theme = Theme.of(context); // 🟢 Grab dynamic theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SearchHeader(topInset: topInset),
            const ActiveFilterChips(),
            Expanded(
              child: Obx(() {
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
