class ApiConfig {
  static String get baseUrl =>
      'https://jobber-city-api-staging.up.railway.app/api';
  // static String get baseUrl => 'http://10.0.2.2:8000/api';
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}
