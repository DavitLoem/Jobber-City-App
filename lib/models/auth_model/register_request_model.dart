enum UserRole { seeker, employer }

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final UserRole role;

  // 1. Constructor (រក្សាទុក)
  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': role.name,
    };
  }
}
