part of 'recruit_screen_view.dart';

class RecruitScreenViewController extends GetxController {
  final JobServices _jobServices = JobServices();

  var jobs = <EmployerJobModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;
  final sortAscending = false.obs;

  static const filterOptions = ['All', 'Active', 'Paused', 'Draft', 'Closed'];

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  String statusGroup(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'published':
        return 'Active';
      case 'pending':
      case 'paused':
        return 'Paused';
      case 'closed':
      case 'expired':
        return 'Closed';
      default:
        return 'Draft';
    }
  }

  Map<String, int> get statusCounts {
    final counts = <String, int>{
      'Active': 0,
      'Paused': 0,
      'Draft': 0,
      'Closed': 0,
    };
    for (final j in jobs) {
      final g = statusGroup(j.status);
      counts[g] = (counts[g] ?? 0) + 1;
    }
    return counts;
  }

  List<EmployerJobModel> get filteredJobs {
    var list = jobs.toList();

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((j) => j.title.toLowerCase().contains(query)).toList();
    }

    if (selectedFilter.value != 'All') {
      list = list
          .where((j) => statusGroup(j.status) == selectedFilter.value)
          .toList();
    }

    list.sort((a, b) {
      final da = DateTime.tryParse(a.createdAt) ?? DateTime(2000);
      final db = DateTime.tryParse(b.createdAt) ?? DateTime(2000);
      return sortAscending.value ? da.compareTo(db) : db.compareTo(da);
    });

    return list;
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  void toggleSortOrder() => sortAscending.value = !sortAscending.value;

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _jobServices.getEmployerJobs();
      jobs.assignAll(data);
    } catch (e) {
      debugPrint('Error loading jobs: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshJobs() async {
    await fetchJobs();
  }
}
