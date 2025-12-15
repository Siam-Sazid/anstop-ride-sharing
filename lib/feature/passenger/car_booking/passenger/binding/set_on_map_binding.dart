import 'package:get/get.dart';
import '../controller/set_on_map_controller.dart';

class SetOnMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetOnMapController>(() => SetOnMapController());
  }
}
