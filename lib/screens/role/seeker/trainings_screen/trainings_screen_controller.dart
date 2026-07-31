part of 'trainings_screen_view.dart';

class TrainingsScreenViewController extends GetxController {
  final TrainingsServices _trainingsServices = TrainingsServices();
  final SeekerProfileServices _profileServices = SeekerProfileServices();

  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // 🟢 បន្ថែម Controllers ២ នេះឲ្យត្រូវនឹង Model
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController certificateUrlController =
      TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainingsData();
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> fetchTrainingsData() async {
    try {
      isLoading.value = true;
      final response = await _profileServices.getSeekerProfile();

      // if (response is Map && response['data'] != null) {
      //   final data = response['data'];
      //   final trainings = data['trainings'] as List<dynamic>? ?? [];

      //   if (trainings.isNotEmpty) {
      //     final trainingData = trainings.last;

      //     courseNameController.text =
      //         trainingData['course_name']?.toString() ?? '';
      //     institutionController.text =
      //         trainingData['institution']?.toString() ?? '';

      //     // 🟢 ចាប់យកទិន្នន័យឲ្យត្រូវនឹង JSON របស់ Model
      //     descriptionController.text =
      //         trainingData['description']?.toString() ?? '';
      //     certificateUrlController.text =
      //         trainingData['certificate_url']?.toString() ?? '';

      //     startDateController.text =
      //         trainingData['start_date']?.toString().split('T').first ?? '';
      //     endDateController.text =
      //         trainingData['end_date']?.toString().split('T').first ?? '';
      //   }
      // }
    } catch (e) {
      debugPrint('Error fetching trainings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTraining() async {
    if (courseNameController.text.trim().isEmpty ||
        institutionController.text.trim().isEmpty ||
        startDateController.text.trim().isEmpty) {
      Get.snackbar(
        'Notice',
        'Course Name, Institution, and Start Date are required!',
      );
      return;
    }

    isLoading.value = true;
    try {
      // 🟢 ប្រើប្រាស់ TraningsModel ឲ្យត្រូវនឹងឈ្មោះហ្វាល់របស់អ្នក
      final newTraining = TraningsModel(
        courseName: courseNameController.text.trim(),
        institution: institutionController.text.trim(),
        startDate: startDateController.text.trim(),
        endDate: endDateController.text.trim().isEmpty
            ? null
            : endDateController.text.trim(),
        description: descriptionController.text.trim(),
        certificateUrl: certificateUrlController.text.trim(),
      );

      await _trainingsServices.addTraining(newTraining);
      Get.toNamed(AppRoutes.trainings);
      Get.snackbar('Success', 'Training saved successfully');
    } catch (e) {
      debugPrint('Error saving training: $e');
      Get.snackbar(
        'Error',
        'Failed to save training',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    courseNameController.dispose();
    institutionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    certificateUrlController.dispose();
    super.onClose();
  }
}
