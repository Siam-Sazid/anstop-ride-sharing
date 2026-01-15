class ChangePasswordResponseModel {
  final int statusCode;
  final bool success;
  final String message;

  ChangePasswordResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      statusCode: json['statusCode'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
