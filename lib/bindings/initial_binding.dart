import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/services/chat/chat_rest_service.dart';
import 'package:jobber_city/core/api/services/chat/chat_ws_service.dart';

import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../core/theme/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);

    Get.put(CategoryController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(MasterDataController(), permanent: true);

    Get.put(NotificationController(), permanent: true);

    Get.put(ChatRestService(), permanent: true);
    Get.put(ChatWsService(), permanent: true);

    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      const storage = FlutterSecureStorage();
      final savedLang = await storage.read(key: 'app_lang');
      final savedCountry = await storage.read(key: 'app_country');

      if (savedLang != null && savedCountry != null) {
        Get.updateLocale(Locale(savedLang, savedCountry));
      }
    } catch (e) {
      // If loading fails, keep default locale
    }
  }
}
