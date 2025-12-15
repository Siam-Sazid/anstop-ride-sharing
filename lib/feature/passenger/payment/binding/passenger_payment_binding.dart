import 'package:get/get.dart';
import '../controller/passenger_payment_controller.dart';

class PassengerPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerPaymentController>(() => PassengerPaymentController());
  }
}
