import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recent_services.dart';
import 'package:jobber_city/core/api/services/role/seeker/job_recommended_services.dart';

class SearchButtonViewController extends GetxController {
  final searchController = TextEditingController();
  final recommendedServices = JobRecommendedServices();
  final recentServices = JobRecentServices();

  // 🟢 ប្រើ FlutterSecureStorage ដើម្បីរក្សាទុកទិន្នន័យ
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _storageKeyRecentSearches = 'recent_searches_list';
  static const String _storageKeyAllJobs = 'all_jobs_cache';
  static const String _storageKeySearchTimestamp = 'search_cache_timestamp';

  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var isSearching = false.obs;

  var allJobs = <dynamic>[].obs;
  var searchResults = <dynamic>[].obs;

  var recentSearches = <String>[].obs;
  var popularSearches = <String>[
    'UI/UX Designer',
    'Flutter Developer',
    'Software Engineer',
    'Data Analyst',
    'Project Manager',
    'Remote',
  ].obs;

  // 🟢 Debounce timer for search
  Timer? _searchDebounceTimer;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 300);

  @override
  void onInit() {
    super.onInit();
    _loadStoredSearches();
    _loadCachedJobs(); // 🟢 Load cached jobs first
    _fetchAllJobs(); // 🟢 Then fetch fresh data

    // 🟢 Add listener with debounce
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _debouncedSearch(searchController.text);
    });
  }

  // 🟢 Debounced search to avoid excessive filtering
  void _debouncedSearch(String query) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_searchDebounceDuration, () {
      _filterJobsByTitle(query);
    });
  }

  // 🟢 ទាញយក និងរក្សាទុក Recent Searches ពី FlutterSecureStorage
  Future<void> _loadStoredSearches() async {
    try {
      final String? jsonString = await _storage.read(
        key: _storageKeyRecentSearches,
      );
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        recentSearches.assignAll(
          decodedList.map((e) => e.toString()).toList().cast<String>(),
        );
      }
    } catch (e) {
      debugPrint("Error loading recent searches: $e");
    }
  }

  // 🟢 ទាញយក Cache Jobs ដែលរក្សាទុក
  Future<void> _loadCachedJobs() async {
    try {
      final String? jsonString = await _storage.read(key: _storageKeyAllJobs);
      if (jsonString != null && jsonString.isNotEmpty) {
        // For now, we'll just use this as a fallback
        debugPrint("Cached jobs found");
      }
    } catch (e) {
      debugPrint("Error loading cached jobs: $e");
    }
  }

  // 🟢 ទាញយក Jobs ពី API និងរក្សាទុក Cache
  Future<void> _fetchAllJobs() async {
    try {
      isLoading.value = true;
      final recommended = await recommendedServices.getJobRecommended();
      final recent = await recentServices.getJobRecent();

      final Map<String, dynamic> uniqueJobs = {};
      for (var job in recommended) {
        uniqueJobs[job.id.toString()] = job;
      }
      for (var job in recent) {
        uniqueJobs[job.id.toString()] = job;
      }

      allJobs.assignAll(uniqueJobs.values.toList());

      // 🟢 Save to secure storage for persistence
      try {
        final jobList = allJobs.map((job) {
          return {
            'id': job.id,
            'title': job.title,
            'companyName': job.companyName,
            'logoUrl': job.logoUrl,
            'location': job.location,
            'minSalary': job.minSalary,
            'maxSalary': job.maxSalary,
          };
        }).toList();

        final String encodedJobs = jsonEncode(jobList);
        await _storage.write(key: _storageKeyAllJobs, value: encodedJobs);

        // Save timestamp
        await _storage.write(
          key: _storageKeySearchTimestamp,
          value: DateTime.now().toIso8601String(),
        );
      } catch (e) {
        debugPrint("Error caching jobs: $e");
      }
    } catch (e) {
      debugPrint("Error fetching jobs for search: $e");
      // 🟢 If API fails, try to load from cache
      await _loadCachedJobs();
    } finally {
      isLoading.value = false;
    }
  }

  // 🟢 Filter jobs by title or company name
  void _filterJobsByTitle(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final lowerQuery = query.toLowerCase().trim();

      // ✅ FIXED: Better filtering that shows full job title
      final results = allJobs.where((job) {
        final titleMatch = job.title.toLowerCase().contains(lowerQuery);
        final companyMatch = job.companyName.toLowerCase().contains(lowerQuery);
        final locationMatch = job.location.toLowerCase().contains(lowerQuery);

        return titleMatch || companyMatch || locationMatch;
      }).toList();

      searchResults.assignAll(results);
    } finally {
      isSearching.value = false;
    }
  }

  // 🟢 Save recent search to FlutterSecureStorage
  Future<void> saveRecentSearch(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    // Remove if already exists
    recentSearches.remove(text);
    // Add to the beginning
    recentSearches.insert(0, text);

    // Keep only last 10 searches
    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }

    try {
      final String encodedList = jsonEncode(recentSearches.toList());
      await _storage.write(key: _storageKeyRecentSearches, value: encodedList);
      debugPrint("✅ Saved search: $text");
    } catch (e) {
      debugPrint("❌ Error saving recent search: $e");
    }
  }

  // 🟢 Fixed: When selecting a suggestion, perform actual search
  void selectSearchQuery(String query) {
    final trimmedQuery = query.trim();

    // Set the search controller text
    searchController.text = trimmedQuery;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: trimmedQuery.length),
    );

    // Perform the search immediately
    _filterJobsByTitle(trimmedQuery);

    // Save to recent searches
    saveRecentSearch(trimmedQuery);
  }

  // 🟢 Clear search and results
  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    searchQuery.value = '';
  }

  // 🟢 Clear all recent searches
  Future<void> clearAllRecentSearches() async {
    try {
      recentSearches.clear();
      await _storage.delete(key: _storageKeyRecentSearches);
      debugPrint("✅ Cleared all recent searches");
    } catch (e) {
      debugPrint("❌ Error clearing recent searches: $e");
    }
  }

  // 🟢 Refresh data from API
  Future<void> refreshJobs() async {
    await _fetchAllJobs();
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
