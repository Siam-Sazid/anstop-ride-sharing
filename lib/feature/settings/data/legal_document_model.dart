/// Enum for legal document types
enum LegalDocumentType {
  privacyPolicy('PRIVACY_POLICY'),
  termsAndConditions('TERMS_AND_CONDITIONS'),
  aboutUs('ABOUT_US');

  final String value;
  const LegalDocumentType(this.value);
}

/// Model class for legal document response
class LegalDocumentModel {
  final String id;
  final String type;
  final String title;
  final String description;

  LegalDocumentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

/// Response wrapper for legal document API
class LegalDocumentResponse {
  final int statusCode;
  final bool success;
  final String message;
  final LegalDocumentModel? data;

  LegalDocumentResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });

  factory LegalDocumentResponse.fromJson(Map<String, dynamic> json) {
    return LegalDocumentResponse(
      statusCode: json['statusCode'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LegalDocumentModel.fromJson(json['data'])
          : null,
    );
  }
}
