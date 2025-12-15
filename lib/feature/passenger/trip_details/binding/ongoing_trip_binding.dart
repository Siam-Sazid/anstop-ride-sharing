import 'package:get/get.dart';
import '../controller/ongoing_trip_controller.dart';

class OngoingTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OngoingTripController>(() => OngoingTripController());
  }
}
