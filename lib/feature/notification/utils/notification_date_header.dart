import 'package:flutter/material.dart';
import '../../../app/utils/app_colors.dart';


class NotificationDateHeader extends StatelessWidget {
  final String dateLabel;

  const NotificationDateHeader({
    Key? key,
    required this.dateLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        dateLabel,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: NotificationColors.dateHeaderText,
        ),
      ),
    );
  }
}
