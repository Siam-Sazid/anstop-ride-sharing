import 'package:get/get.dart';
import '../controller/my_ride_controller.dart';

class MyRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRideController>(() => MyRideController());
  }
}
