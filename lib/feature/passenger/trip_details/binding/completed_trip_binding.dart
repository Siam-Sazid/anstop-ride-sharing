import 'package:get/get.dart';
import '../controller/completed_trip_controller.dart';

class CompletedTripBinding extends Bindings {
  @override
  void dependencies() {
    final rideId = Get.arguments as String? ?? '';
    Get.lazyPut<CompletedTripController>(() => CompletedTripController(rideId: rideId ));
  }
}
