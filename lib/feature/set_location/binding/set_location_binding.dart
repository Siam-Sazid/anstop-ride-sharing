import 'package:get/get.dart';
import 'package:ride_sharing/feature/set_location/controller/set_location_controller.dart';




class SetLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SetLocationController());
  }
}