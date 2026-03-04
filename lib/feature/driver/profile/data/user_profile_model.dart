class UserProfileResponse {
  final bool success;
  final String message;
  final UserProfileData data;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? address;
  final String? profilePicture;

  UserProfileData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.address,
    this.profilePicture,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      profilePicture: json['profilePicture'],
    );
  }
}
