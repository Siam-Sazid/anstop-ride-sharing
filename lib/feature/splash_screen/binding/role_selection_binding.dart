import 'package:get/get.dart';
import '../controller/role_selection_controller.dart';

class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectionController>(() => RoleSelectionController());
  }
}
