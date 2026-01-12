import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/feature/messages/message_utils/chat_bubble.dart';
import 'package:ride_sharing/feature/messages/models/message_models.dart';
import 'package:ride_sharing/feature/messages/view/block_dialog.dart';
import 'package:ride_sharing/feature/messages/view/media_grid_screen.dart';
import 'package:ride_sharing/feature/messages/view/report_screen.dart';
import '../../../app/utils/app_colors.dart';
import '../../../l10n/l10n_helper.dart';


class ChatScreen extends StatefulWidget {
  final String userName;
  final String userStatus;

  const ChatScreen({
    Key? key,
    required this.userName,
    required this.userStatus,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'Hi, I\'m looking to get my MacBook pad cleaned. Do you offer that service?',
      isSent: false,
      time: '9:32 AM',
    ),
    ChatMessage(
      text: 'Yes, we do! Can you tell me the size and condition of your pool?',
      isSent: false,
      time: '9:33 AM',
    ),
    ChatMessage(
      text: 'It\'s medium-sized, I think that. Haven\'t cleaned it in 3 months, so there\'s algae and leaves.',
      isSent: false,
      time: '9:34 AM',
    ),
    ChatMessage(
      text: 'Got it. We recommend a thorough cleaning. What would you like to do it quickly?',
      isSent: false,
      time: '9:35 AM',
    ),
    ChatMessage(
      text: 'Is Saturday morning feasible?',
      isSent: true,
      time: '9:36 AM',
    ),
    ChatMessage(
      text: 'Let me check... Yes, we have a local at 10 AM. Does that work?',
      isSent: false,
      time: '9:37 AM',
    ),
  ];

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              AppLocalization.tr.viewMediaOption,
                  () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MediaGridScreen(),
                  ),
                );
              },
            ),
            _buildMenuOption(
              AppLocalization.tr.reportOption,
                  () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportScreen(),
                  ),
                );
              },
            ),
            _buildMenuOption(
              AppLocalization.tr.blockOption,
                  () {
                Navigator.pop(context);
                _showBlockDialog();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => BlockDialog(
        userName: widget.userName,
        onBlock: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildMenuOption(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MessagingColors.primaryText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: MessagingColors.primaryGreen,
              child: Text(
                widget.userName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: MessagingColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.userStatus,
                  style: const TextStyle(
                    color: MessagingColors.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: MessagingColors.primaryText,
            ),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index].text,
                  isSent: messages[index].isSent,
                  time: messages[index].time,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: MessagingColors.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: MessagingColors.backgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: AppLocalization.tr.typeMessageHint,
                  hintStyle: const TextStyle(
                    color: MessagingColors.secondaryText,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: MessagingColors.secondaryText,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: MessagingColors.primaryGreen,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
