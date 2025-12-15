import 'package:get/get.dart';
import '../controller/passenger_registration_controller.dart';

class PassengerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerRegistrationController>(() => PassengerRegistrationController());
  }
}
