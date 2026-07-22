import 'package:get/get.dart';
import 'package:jobber_city/core/api/services/category_services.dart';
import 'package:jobber_city/models/category_model.dart';

class CategoryController extends GetxController {
  final _categoryService = CategoryServices();

  final categories = <CategoryModel>[].obs;
  final categoiesCache = <String, List<CategoryModel>>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories({String? search}) async {
    isLoading.value = true;
    try {
      final res = await _categoryService.getCategories(search: search);
      categories.assignAll(res);
    } finally {
      isLoading.value = false;
    }
  }
}
