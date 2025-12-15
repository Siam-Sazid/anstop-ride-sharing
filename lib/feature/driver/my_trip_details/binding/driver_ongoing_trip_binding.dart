import 'package:get/get.dart';
import '../controller/driver_ongoing_trip_controller.dart';

class DriverOngoingTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverOngoingTripController>(() => DriverOngoingTripController());
  }
}
