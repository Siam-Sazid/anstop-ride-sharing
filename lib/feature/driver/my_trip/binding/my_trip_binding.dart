import 'package:get/get.dart';
import '../controller/my_trip_controller.dart';

class MyTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTripController>(() => MyTripController());
  }
}
