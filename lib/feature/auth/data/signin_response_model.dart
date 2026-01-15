class SignInResponseModel {
  final int statusCode;
  final String message;
  final SignInData data;

  SignInResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SignInData.fromJson(json['data'] ?? {}),
    );
  }
}

class SignInData {
  final String accessToken;
  final String refreshToken;
  final List<String> role;
  final bool needsVerification;
  final String? userId;
  final String? name;
  final String? profilePicture;

  SignInData({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.needsVerification,
    this.userId,
    this.name,
    this.profilePicture,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) {
    // Try to get user info from 'user' object or directly from data
    final user = json['user'] as Map<String, dynamic>?;
    return SignInData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      role: json['role'] != null
          ? List<String>.from(json['role'])
          : [],
      needsVerification: json['needsVerification'] ?? false,
      userId: user?['_id'] ?? json['userId'] ?? json['_id'],
      name: user?['name'] ?? json['name'],
      profilePicture: user?['profilePicture'] ?? json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      'needsVerification': needsVerification,
      'userId': userId,
      'name': name,
      'profilePicture': profilePicture,
    };
  }
}
