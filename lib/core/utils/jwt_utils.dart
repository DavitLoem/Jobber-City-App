import 'dart:convert';

/// ថតយកទិន្នន័យ (Claims) ចេញពី JWT Access Token ដោយផ្ទាល់លើ Client ដោយមិនចាំបាច់
/// ហៅ API ណាមួយ ឬ Package បន្ថែម (JWT payload គ្រាន់តែជា Base64Url JSON ធម្មតា)។
///
/// ប្រើសម្រាប់ទាញយក User ID (`sub` claim) ព្រោះ [TokenStorage] បច្ចុប្បន្នមិនទាន់
/// រក្សាទុក User ID ដោយផ្ទាល់ទេ (មានតែ Token/Role/Onboarding Status) — ការបន្ថែម Utility
/// នេះជាដំណោះស្រាយដែលមិនប៉ះពាល់ដល់ Auth Flow ដែលកំពុងដំណើរការល្អស្រាប់ហើយ។
///
/// 🎯 សំខាន់៖ នេះជា Decode សុទ្ធៗ (មិនមាន Signature Verification ទេ) — សុវត្ថិភាព
/// នៅតែធានាដោយ Backend ជានិច្ច (រាល់ Request ត្រូវឆ្លងកាត់ការផ្ទៀងផ្ទាត់ Token ពិតប្រាកដ
/// នៅ Server-side) Client គ្រាន់តែអានទិន្នន័យដែលមានស្រាប់ចេញមកប្រើប្រាស់ប៉ុណ្ណោះ។
class JwtUtils {
  JwtUtils._();

  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// ទាញយក User ID ពី claim `sub` (សូមមើល `create_access_token()` ក្នុង
  /// `src/core/security.py` នៃ Backend — `{"sub": str(user["_id"]), "role": ...}`)
  static String? getUserId(String token) {
    return decodePayload(token)?['sub']?.toString();
  }
}
