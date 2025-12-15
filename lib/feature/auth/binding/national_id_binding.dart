import 'package:get/get.dart';
import '../controller/national_id_controller.dart';

class NationalIdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NationalIdController>(() => NationalIdController());
  }
}
