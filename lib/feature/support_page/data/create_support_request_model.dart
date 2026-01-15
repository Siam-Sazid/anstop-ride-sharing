/// Request model for POST /supports
class CreateSupportRequestModel {
  final String subject;
  final String message;

  CreateSupportRequestModel({
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
    };
  }
}
