import 'package:get/get.dart';
import '../controller/registration_controller.dart';

class PassengerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}
