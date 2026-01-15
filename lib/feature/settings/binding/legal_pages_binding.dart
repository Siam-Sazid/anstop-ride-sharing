import 'package:get/get.dart';
import '../controller/legal_pages_controller.dart';

class LegalPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalPagesController>(() => LegalPagesController());
  }
}
