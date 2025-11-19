class Message {
  final String name;
  final String message;
  final String time;
  final String? avatarUrl;
  final bool hasUnread;

  Message({
    required this.name,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.hasUnread = false,
  });
}

class ChatMessage {
  final String text;
  final bool isSent;
  final String time;

  ChatMessage({
    required this.text,
    required this.isSent,
    required this.time,
  });
}