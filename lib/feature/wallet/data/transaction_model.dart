class TransactionResponseModel {
  final bool success;
  final String message;
  final TransactionPagination data;

  TransactionResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TransactionPagination.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionPagination {
  final List<TransactionModel> results;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  TransactionPagination({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory TransactionPagination.fromJson(Map<String, dynamic> json) {
    return TransactionPagination(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
    );
  }
}
class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String status;
  final String? accountNumber;
  final String? accountHolderName;
  final String? accountType;
  final String? bankName;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.accountNumber,
    this.accountHolderName,
    this.accountType,
    this.bankName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      accountType: json['accountType'],
      bankName: json['bankName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

