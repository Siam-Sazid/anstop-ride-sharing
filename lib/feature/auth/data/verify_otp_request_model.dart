class VerifyOtpRequestModel {
  final String otp;
  final String email;
  final String type;

  VerifyOtpRequestModel({
    required this.otp,
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'email': email,
      'type': type,
    };
  }
}

// Valid OTP types
class OtpType {
  static const String emailVerification = 'EMAIL_VERIFICATION';
  static const String passwordReset = 'PASSWORD_RESET';
}
