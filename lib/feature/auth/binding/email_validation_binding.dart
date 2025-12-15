import 'package:get/get.dart';
import '../controller/email_validation_controller.dart';

class EmailValidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailValidationController>(() => EmailValidationController());
  }
}
