import 'package:get/get.dart';
import '../controller/driver_completed_trip_controller.dart';

class DriverCompletedTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverCompletedTripController>(() => DriverCompletedTripController());
  }
}
