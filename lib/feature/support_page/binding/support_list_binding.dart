import 'package:get/get.dart';
import '../controller/support_list_controller.dart';

class SupportListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportListController>(() => SupportListController());
  }
}
