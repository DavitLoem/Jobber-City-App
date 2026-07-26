part of 'job_detail_view.dart';

class JobDetailController extends GetxController {
  // Whichever model was passed in via Get.arguments — kept so we can hand
  // an updated copy back to the caller (home screen) when the user
  // bookmarks the job from this screen.
  dynamic _job;

  var id = ''.obs;
  var title = ''.obs;
  var minSalary = 0.0.obs;
  var maxSalary = 0.0.obs;
  var salaryPeriod = ''.obs;
  var companyName = ''.obs;
  var logoUrl = ''.obs;
  var location = ''.obs;
  var employmentType = ''.obs;
  var workType = ''.obs; // only present on JobRecentModel
  var isSaved = false.obs;

  var isDescriptionExpanded = false.obs;
  var isApplying = false.obs;
  var hasApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    _job = Get.arguments;
    _mapJobFields();
  }

  // Both JobRecommendedModel and JobRecentModel expose the same core
  // fields; only JobRecentModel additionally has `workType`. Branching on
  // type (rather than blind dynamic access) keeps this safe if either
  // model's shape changes later.
  void _mapJobFields() {
    final job = _job;
    if (job == null) return;

    if (job is JobRecentModel) {
      id.value = job.id;
      title.value = job.title;
      minSalary.value = job.minSalary;
      maxSalary.value = job.maxSalary;
      salaryPeriod.value = job.salaryPeriod;
      companyName.value = job.companyName;
      logoUrl.value = job.logoUrl;
      location.value = job.location;
      employmentType.value = job.employmentType;
      workType.value = job.workType;
      isSaved.value = job.isSaved;
    } else if (job is JobRecommendedModel) {
      id.value = job.id.toString();
      title.value = job.title;
      minSalary.value = job.minSalary;
      maxSalary.value = job.maxSalary;
      salaryPeriod.value = job.salaryPeriod;
      companyName.value = job.companyName;
      logoUrl.value = job.logoUrl;
      location.value = job.location;
      employmentType.value = job.employmentType;
      isSaved.value = job.isSaved;
    }
  }

  String get salaryText {
    final min = minSalary.value.toInt();
    final max = maxSalary.value.toInt();
    final period = _periodShort(salaryPeriod.value);
    return "\$$min - \$$max/$period";
  }

  String _periodShort(String period) {
    final p = period.toLowerCase();
    if (p.contains('year')) return 'yr';
    if (p.contains('week')) return 'wk';
    if (p.contains('month')) return 'mo';
    return p.isEmpty ? 'mo' : p;
  }

  void toggleSave() {
    isSaved.value = !isSaved.value;

    // Hand an updated copy of the model back to whichever screen pushed
    // this route, so its list stays in sync (mirrors the
    // `.then((updatedJob) {...})` handling already used in
    // home_seeker_view.dart).
    final job = _job;
    if (job is JobRecentModel) {
      _job = job.copyWith(isSaved: isSaved.value);
    } else if (job is JobRecommendedModel) {
      _job = job.copyWith(isSaved: isSaved.value);
    }
  }

  void applyNow() async {
    if (hasApplied.value || isApplying.value) return;
    isApplying.value = true;

    // TODO: replace with the real "apply to job" API call.
    await Future.delayed(const Duration(milliseconds: 900));

    isApplying.value = false;
    hasApplied.value = true;
    Get.snackbar(
      "Application sent",
      "Your application to ${companyName.value} has been submitted",
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successBackground,
      colorText: AppColors.success,
    );
  }

  /// The current job model (with any bookmark change applied), to hand
  /// back to the screen that pushed this route — e.g.
  /// `Get.back(result: controller.currentJob)`.
  dynamic get currentJob => _job;

  // ── Placeholder content ──
  // Neither JobRecommendedModel nor JobRecentModel currently carries a
  // description, requirements, or benefits from the API. These give the
  // screen something real to render — swap for actual model/API fields
  // once the backend supports them.

  String get placeholderDescription =>
      "We're looking for a ${title.value.isNotEmpty ? title.value : 'motivated professional'} "
      "to join the team at ${companyName.value.isNotEmpty ? companyName.value : 'our company'}. "
      "You'll collaborate closely with cross-functional teams to plan, build, and ship work that "
      "directly impacts the product and its users. This role offers room to grow, ownership over "
      "meaningful projects, and a supportive team culture that values clear communication and "
      "steady progress over long hours.";

  List<String> get placeholderRequirements => const [
    "Proven experience in a similar role",
    "Strong communication and teamwork skills",
    "Comfortable working in a fast-paced environment",
    "Good problem-solving and time-management skills",
  ];

  List<String> get placeholderBenefits => const [
    "Health insurance",
    "Flexible hours",
    "Paid time off",
    "Performance bonus",
  ];
}
