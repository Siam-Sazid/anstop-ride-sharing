import 'package:get/get.dart';

class MessageListController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxList<dynamic> conversations = <dynamic>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  // ==================== Business Logic ====================
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual API call to load conversations
      await Future.delayed(const Duration(seconds: 1));

      conversations.value = [];
      unreadCount.value = 0;

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMessages() async {
    await loadConversations();
  }

  void searchConversations(String query) {
    searchQuery.value = query;
    // TODO: Implement search logic
  }

  void navigateToChat(dynamic conversation) {
    // Get.toNamed(AppRoutes.chatScreen, arguments: conversation);
  }

  void deleteConversation(dynamic conversation) {
    // TODO: Implement delete conversation
    conversations.remove(conversation);
  }
}
