import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // ប្រើ 10.0.2.2 សម្រាប់ Android Emulator
  // ប្រសិនបើអ្នកតេស្តលើ iOS Simulator សូមដូរទៅ 'http://127.0.0.1:8000' or http://10.0.2.2:8000
  // static const String baseUrl = "https://jobber-city-api-staging.up.railway.app/api";

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api';
  static const int connectionTimeout = 4;
  static const int receiveTimeout = 4;
}
