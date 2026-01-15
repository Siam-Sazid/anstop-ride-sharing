import 'package:get/get.dart';
import '../controller/create_support_controller.dart';

class CreateSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSupportController>(() => CreateSupportController());
  }
}
