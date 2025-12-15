import 'package:get/get.dart';
import '../controller/driver_registration_controller.dart';

class DriverRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverRegistrationController>(() => DriverRegistrationController());
  }
}
