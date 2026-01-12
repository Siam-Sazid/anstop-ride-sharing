class SignUpRequestModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String? phoneNumber;
  final String? gender;
  final String? dateOfBirth;

  SignUpRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };

    // Add optional fields only if they are not null
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      data['phoneNumber'] = phoneNumber;
    }
    if (gender != null && gender!.isNotEmpty) {
      data['gender'] = gender;
    }
    if (dateOfBirth != null && dateOfBirth!.isNotEmpty) {
      data['dateOfBirth'] = dateOfBirth;
    }

    return data;
  }
}
