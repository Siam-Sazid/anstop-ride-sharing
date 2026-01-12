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

  SignInData({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.needsVerification,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) {
    return SignInData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      role: json['role'] != null
          ? List<String>.from(json['role'])
          : [],
      needsVerification: json['needsVerification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      'needsVerification': needsVerification,
    };
  }
}
