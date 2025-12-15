import 'package:get/get.dart';
import '../controller/completed_trip_controller.dart';

class CompletedTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletedTripController>(() => CompletedTripController());
  }
}
