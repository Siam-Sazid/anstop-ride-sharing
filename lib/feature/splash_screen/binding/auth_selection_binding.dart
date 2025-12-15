import 'package:get/get.dart';
import '../controller/auth_selection_controller.dart';

class AuthSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthSelectionController>(() => AuthSelectionController());
  }
}
