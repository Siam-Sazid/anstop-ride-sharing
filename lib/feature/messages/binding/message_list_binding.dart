import 'package:get/get.dart';
import '../controller/message_list_controller.dart';

class MessageListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageListController>(() => MessageListController());
  }
}
