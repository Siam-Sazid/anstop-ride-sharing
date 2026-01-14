import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../services/socket_services.dart';
import '../models/message_models.dart';
import '../service/message_service.dart';

class ChatController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController messageTEController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // ==================== Services ====================
  final MessageService _messageService = MessageService();
  final Logger _logger = Logger();
  late SocketIoService _socketService;

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isConnected = false.obs;

  // ==================== Parameters ====================
  String conversationId = '';
  String currentUserId = '';
  String currentUserName = '';
  String? currentUserProfilePicture;
  String userName = '';
  String userStatus = '';

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _initializeSocket();
    _loadCurrentUserInfo();
  }

  @override
  void onClose() {
    messageTEController.dispose();
    scrollController.dispose();
    _socketService.offNewMessage();
    super.onClose();
  }

  // ==================== Initialization ====================
  void _loadArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      conversationId = args['conversationId'] ?? '';
      userName = args['userName'] ?? 'User';
      userStatus = args['userStatus'] ?? 'Online';
    }
  }

  Future<void> _loadCurrentUserInfo() async {
    final userInfo = await _messageService.getCurrentUserInfo();
    currentUserId = userInfo['userId'] ?? '';
    currentUserName = userInfo['userName'] ?? 'Me';
    currentUserProfilePicture = userInfo['profilePicture'];
    if (conversationId.isNotEmpty) {
      loadMessages();
    }
  }

  void _initializeSocket() {
    try {
      _socketService = Get.find<SocketIoService>();
      _socketService.connect();

      // Listen for connection status
      ever(_socketService.isConnected, (connected) {
        isConnected.value = connected;
      });

      // Listen for new messages
      _socketService.onNewMessage((data) {
        _logger.i('New message received: $data');
        _handleNewMessage(data);
      });
    } catch (e) {
      _logger.e('Error initializing socket: $e');
    }
  }

  void _handleNewMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Check if message is for this conversation
      final msgConversationId = data['conversationId'] ?? '';
      if (msgConversationId == conversationId) {
        // Parse sender - could be string ID or object
        String senderId = '';
        String senderName = 'Unknown';
        String? senderProfilePicture;

        if (data['sender'] is Map) {
          senderId = data['sender']['_id'] ?? '';
          senderName = data['sender']['name'] ?? 'Unknown';
          senderProfilePicture = data['sender']['profilePicture'];
        } else if (data['sender'] is String) {
          senderId = data['sender'];
          // Use userName from arguments if this is from the other user
          senderName = senderId == currentUserId ? currentUserName : userName;
        }

        // Don't add if it's our own message (we already added it optimistically)
        if (senderId == currentUserId) {
          return;
        }

        final newMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: MessageSender(
            id: senderId,
            name: senderName,
            profilePicture: senderProfilePicture,
          ),
          conversationId: msgConversationId,
          text: data['text'] ?? '',
          attachments: data['attachments'] != null && data['attachments'].toString().isNotEmpty
              ? [data['attachments'].toString()]
              : [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSent: false,
        );

        messages.add(newMessage);
        messages.refresh(); // Force UI update
        _scrollToBottom();
      }
    }
  }

  // ==================== Business Logic ====================
  Future<void> loadMessages() async {
    if (conversationId.isEmpty) {
      errorMessage.value = 'Conversation ID is missing';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _messageService.getMessages(conversationId);

      if (response.isSuccess) {
        final messagesResponse = MessagesResponse.fromJson(
          response.responseData,
          currentUserId,
        );
        messages.value = messagesResponse.data.results;
        _scrollToBottom();
      } else {
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load messages',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      _logger.e('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageTEController.text.trim();
    if (text.isEmpty) return;

    try {
      _logger.i('Sending message: $text');
      _logger.i('Current user ID: $currentUserId');
      _logger.i('Conversation ID: $conversationId');

      // Send message via socket
      _socketService.sendMessage(
        conversationId: conversationId,
        text: text,
      );

      // Optimistically add message to UI
      final newMessage = ChatMessage.local(
        currentUserId: currentUserId,
        currentUserName: currentUserName,
        currentUserProfilePicture: currentUserProfilePicture,
        conversationId: conversationId,
        text: text,
      );

      _logger.i('Adding message to list. Current count: ${messages.length}');
      messages.add(newMessage);
      messages.refresh(); // Force UI update
      _logger.i('Message added. New count: ${messages.length}');

      messageTEController.clear();
      _scrollToBottom();
    } catch (e) {
      errorMessage.value = e.toString();
      _logger.e('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _scrollToBottom() {
    // Use a slight delay to ensure the list has been rebuilt with the new message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMedia() async {
    // TODO: Implement media sending with attachments
  }

  void blockUser() {
    // TODO: Implement block user functionality
  }

  void reportUser() {
    // TODO: Navigate to report screen
  }

  void onTyping(bool typing) {
    isTyping.value = typing;
    // TODO: Send typing indicator to server
  }

  Future<void> refreshMessages() async {
    await loadMessages();
  }
}
