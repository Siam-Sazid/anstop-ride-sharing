import 'package:flutter/material.dart';
import '../../../app/utils/app_colors.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final String time;
  final String? senderName;
  final String? senderProfilePicture;
  final bool showSenderInfo;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSent,
    required this.time,
    this.senderName,
    this.senderProfilePicture,
    this.showSenderInfo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Profile picture for received messages
          if (!isSent && showSenderInfo) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ] else if (!isSent) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender name for received messages
                if (!isSent && showSenderInfo && senderName != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      senderName!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MessagingColors.primaryText,
                      ),
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSent
                        ? MessagingColors.messageBubbleSent
                        : MessagingColors.messageBubbleReceived,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isSent
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isSent
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: MessagingColors.primaryText,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MessagingColors.timeText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSent) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (senderProfilePicture != null && senderProfilePicture!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(senderProfilePicture!),
        backgroundColor: MessagingColors.primaryGreen,
        onBackgroundImageError: (_, __) {},
        child: senderProfilePicture == null
            ? Text(
                (senderName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: MessagingColors.primaryGreen,
      child: Text(
        (senderName ?? 'U')[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
