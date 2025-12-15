import 'package:get/get.dart';
import '../controller/driving_license_controller.dart';

class DrivingLicenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrivingLicenseController>(() => DrivingLicenseController());
  }
}
