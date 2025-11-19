import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/messages/models/message_models.dart';
import '../../../app/utils/app_colors.dart';



class MessageListItem extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;

  const MessageListItem({
    Key? key,
    required this.message,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: MessagingColors.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: MessagingColors.primaryGreen,
              child: message.avatarUrl != null
                  ? ClipOval(
                child: Image.network(
                  message.avatarUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar();
                  },
                ),
              )
                  : _buildDefaultAvatar(),
            ),

            const SizedBox(width: 12),

            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MessagingColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.hasUnread
                          ? MessagingColors.primaryText
                          : MessagingColors.secondaryText,
                      fontWeight: message.hasUnread
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Time and Unread Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MessagingColors.timeText,
                  ),
                ),
                if (message.hasUnread) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: MessagingColors.unreadIndicator,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Text(
      message.name[0].toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
