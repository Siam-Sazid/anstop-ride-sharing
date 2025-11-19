import 'package:flutter/material.dart';

enum NotificationType {
  payment,
  discount,
  creditCard,
  wallet,
}

class NotificationModel {
  final String title;
  final String description;
  final NotificationType type;
  final DateTime dateTime;

  NotificationModel({
    required this.title,
    required this.description,
    required this.type,
    required this.dateTime,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.payment:
        return Icons.credit_card;
      case NotificationType.discount:
        return Icons.local_offer;
      case NotificationType.creditCard:
        return Icons.credit_card_outlined;
      case NotificationType.wallet:
        return Icons.account_balance_wallet_outlined;
    }
  }
}

class NotificationGroup {
  final String dateLabel;
  final List<NotificationModel> notifications;

  NotificationGroup({
    required this.dateLabel,
    required this.notifications,
  });
}
