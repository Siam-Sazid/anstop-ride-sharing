import 'package:get/get.dart';
import '../controller/ongoing_trip_controller.dart';

class OngoingTripBinding extends Bindings {
  @override
  void dependencies() {
    final rideId = Get.arguments as String? ?? '';
    Get.lazyPut<OngoingTripController>(() => OngoingTripController(rideId: rideId));
  }
}
