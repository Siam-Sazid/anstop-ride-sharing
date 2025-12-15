import 'package:get/get.dart';
import '../controller/driver_trip_flow_controller.dart';

class DriverTripFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverTripFlowController>(() => DriverTripFlowController());
  }
}
