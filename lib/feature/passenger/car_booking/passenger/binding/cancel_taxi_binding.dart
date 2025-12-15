import 'package:get/get.dart';
import '../controller/cancel_taxi_controller.dart';

class CancelTaxiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancelTaxiController>(() => CancelTaxiController());
  }
}
