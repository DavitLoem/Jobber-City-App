part of 'splash_view.dart';

class SplashViewController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController bgCtrl;
  late AnimationController logoCtrl;
  late AnimationController taglineCtrl;
  late AnimationController loaderCtrl;
  late AnimationController shimmerCtrl;

  // ── Bg blob animations ──
  late Animation<double> blob1Scale;
  late Animation<double> blob2Scale;
  late Animation<Offset> blob1Pos;
  late Animation<Offset> blob2Pos;

  // ── Logo ──
  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<double> glowOpacity;

  // ── Tagline ──
  late Animation<double> taglineFade;
  late Animation<Offset> taglineSlide;
  late Animation<double> subtitleFade;

  // ── Loader bar ──
  late Animation<double> loaderFade;
  late Animation<double> loaderProgress;

  // ── Shimmer ──
  late Animation<double> shimmer;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
  }

  // ប្រើប្រាស់ onReady ដើម្បីចាប់ផ្តើម Animation នៅពេលដែល UI ត្រូវបាន Render ពេញលេញ
  @override
  void onReady() {
    super.onReady();
    _startSequence();
  }

  void _setupAnimations() {
    // Background blobs
    bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    blob1Scale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: bgCtrl, curve: Curves.easeOut));
    blob2Scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: bgCtrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    blob1Pos = Tween<Offset>(
      begin: const Offset(0.08, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: bgCtrl, curve: Curves.easeOut));
    blob2Pos =
        Tween<Offset>(
          begin: const Offset(-0.08, -0.08),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: bgCtrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    // Logo
    logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoCtrl, curve: Curves.elasticOut));
    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: logoCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: logoCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Tagline
    taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    taglineFade = CurvedAnimation(
      parent: taglineCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    taglineSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: taglineCtrl,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );
    subtitleFade = CurvedAnimation(
      parent: taglineCtrl,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );

    // Loader bar
    loaderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    loaderFade = CurvedAnimation(
      parent: loaderCtrl,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
    );
    loaderProgress = CurvedAnimation(
      parent: loaderCtrl,
      curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
    );

    // Shimmer sweep
    shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    shimmer = shimmerCtrl;
  }

  Future<void> _startSequence() async {
    // មិនបាច់ឆែកទេ ព្រោះវានៅដើមគេមិនទាន់មានការរង់ចាំ
    bgCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    // 🎯 បន្ថែមការការពារទី១៖ បើ Controller ត្រូវបិទហើយ (ឧ. លោតទៅ Login បាត់) សូមបញ្ឈប់ការងារ
    if (isClosed) return;
    logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 700));
    // 🎯 បន្ថែមការការពារទី២
    if (isClosed) return;
    taglineCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    // 🎯 បន្ថែមការការពារទី៣
    if (isClosed) return;
    loaderCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 2000));
    // 🎯 បន្ថែមការការពារចុងក្រោយ មុននឹងហៅការឆែក Auto Login
    if (isClosed) return;

    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    try {
      String? token = await TokenStorage.getAccessToken();
      String? role = await TokenStorage.getUserRole();
      bool onboardingCompleted = await TokenStorage.getOnboardingStatus();
      bool isProfileCompleted = await TokenStorage.getProfileCompletedStatus();

      // ២. លក្ខខណ្ឌកាត់ក្តី
      if (token != null && token.isNotEmpty) {
        // បើមាន Token (មានន័យថាគាត់ធ្លាប់ Login ឬ Verify រួច)
        if (role == 'employer') {
          if (isProfileCompleted) {
            Get.offAllNamed(AppRoutes.mainScreenEmployer);
          } else {
            Get.offAllNamed(AppRoutes.companyProfile);
          }
        } else {
          if (onboardingCompleted) {
            Get.offAllNamed(AppRoutes.mainScreenSeeker);
          } else {
            Get.offAllNamed(AppRoutes.location);
          }
        }
      } else {
        // បើគ្មាន Token ទេ (មិនទាន់ Login)
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      // ការពារក្រែងលោមាន Error អាន Storage លោតទៅ Login ឱ្យសុវត្ថិភាពសិន
      Get.offAllNamed(AppRoutes.login);
    }
  }

  // កុំភ្លេច Dispose Controllers ទាំងអស់ដើម្បីការពារការលេចធ្លាយ Memory
  @override
  void onClose() {
    bgCtrl.dispose();
    logoCtrl.dispose();
    taglineCtrl.dispose();
    loaderCtrl.dispose();
    shimmerCtrl.dispose();
    super.onClose();
  }
}
