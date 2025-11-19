import 'package:flutter/material.dart';
import '../../../app/utils/app_colors.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final String time;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSent,
    required this.time,
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
          if (!isSent) const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
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
}
