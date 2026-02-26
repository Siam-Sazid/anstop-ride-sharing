import 'package:get/get.dart';

import '../controller/pick_up_location_controller.dart';




class PickUpLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PickUpLocationController(), permanent: true);
  }
}
