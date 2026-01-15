/// Model for a single support message
class SupportMessageModel {
  final String id;
  final String subject;
  final String message;
  final String status;
  final DateTime createdAt;

  SupportMessageModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['_id'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

/// Response model for GET /supports/my-messages
class SupportListResponse {
  final bool success;
  final String message;
  final List<SupportMessageModel> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  SupportListResponse({
    required this.success,
    required this.message,
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory SupportListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final resultsList = data['results'] as List<dynamic>? ?? [];

    return SupportListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      results: resultsList
          .map((item) => SupportMessageModel.fromJson(item))
          .toList(),
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 10,
      totalPages: data['totalPages'] ?? 1,
      totalResults: data['totalResults'] ?? 0,
    );
  }
}
