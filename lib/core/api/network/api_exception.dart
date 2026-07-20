// ថ្នាក់នេះប្រើសម្រាប់ខ្ចប់សារ Error ដែលយើងបានបកប្រែរួចរាល់
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  final String? errorCode;
  final String? existingRole;

  ApiException(
    this.message, {
    this.statusCode,
    this.errorCode,
    this.existingRole,
  });

  @override
  String toString() => message;
}
