import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ??
      'https://jobber-city-api-staging.up.railway.app/api';
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}
