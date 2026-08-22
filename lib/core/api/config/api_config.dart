import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiConfig {
  // static String get baseUrl =>
  //     dotenv.env['BASE_URL'] ??
  //     'https://jobber-city-staging.up.railway.app/api';
  // static String get baseUrl => 'https://jobber-city-staging.up.railway.app/api';
  //
  // 🎯 ជួសជុល៖ គ្រប់ Endpoint ទាំងអស់ក្នុង App (ឧ. '/auth/login', '/seeker/profile/')
  // សរសេរដោយមិនដាក់បុព្វបទ '/api/' ព្រោះ baseUrl ដើមមាន '/api' ស្រាប់ (សូមមើល URL
  // Railway ខាងលើ ដែលបញ្ចប់ដោយ '/api')។ បើ baseUrl សម្រាប់ localhost មិនដាក់ '/api'
  // ភ្ជាប់ខាងចុងដែរ Request ទាំងអស់នឹងវាយចូល http://host:8000/auth/login ជំនួសឱ្យ
  // http://host:8000/api/auth/login ដែលមិនត្រូវនឹង Route ណាមួយក្នុង FastAPI សោះ (404 all-around)។
  //
  // 🎯 Platform-aware host៖ Android Emulator ត្រូវការ `10.0.2.2` ជា Alias ទៅកាន់
  // Localhost របស់ម៉ាស៊ីនម្ចាស់ ប៉ុន្តែ iOS Simulator មិនស្គាល់ Address នេះទាល់តែសោះ
  // (ត្រូវការ `127.0.0.1` ទៅវិញ ព្រោះ iOS Simulator ចែករ៉ែក Network ជាមួយ Mac ផ្ទាល់)។
  // ដូច្នេះបើកម្មវិធីរត់ក្នុង Android Emulator មួយ និង iOS Simulator មួយក្នុងពេលតែមួយ
  // (ឧ. សម្រាប់តេស្ត Real-time Chat រវាងគណនីពីរ) ត្រូវឆែក Platform ដោយស្វ័យប្រវត្តិ
  // ទើបទាំងពីរភ្ជាប់ចូល Backend បានត្រឹមត្រូវក្នុងពេលតែមួយ។
  static String get _localHost {
    if (!kIsWeb && Platform.isAndroid) return '10.0.2.2';
    return '127.0.0.1'; // iOS Simulator, macOS desktop run, or web
  }

  static String get baseUrl => 'http://$_localHost:8000/api';

  /// 🎯 សម្រាប់ Real-time Chat WebSocket (`/api/chat/ws`) — ដូច [baseUrl] ជាមូលដ្ឋាន
  /// តែប្តូរ Scheme ពី http(s) ទៅ ws(s) វិញ ព្រោះ WebSocket មិនប្រើ http:// ទេ។
  static String get wsBaseUrl => baseUrl.replaceFirst('http', 'ws');

  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}
