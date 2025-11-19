import 'package:get/get.dart';
import 'package:ride_sharing/feature/driver/homepage/controller/driver_home_controller.dart';



class DriverHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverHomeScreenController());
  }
}