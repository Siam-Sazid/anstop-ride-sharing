import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  // ==================== State ====================
  final RxString selectedRole = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== Business Logic ====================
  void selectRole(String role) {
    selectedRole.value = role;
  }

  void selectDriver() {
    selectedRole.value = 'driver';
    // Get.toNamed(AppRoutes.driverAuthSelectionScreen);
  }

  void selectPassenger() {
    selectedRole.value = 'passenger';
    // Get.toNamed(AppRoutes.passengerAuthSelectionScreen);
  }

  void navigateToAuth() {
    if (selectedRole.value == 'driver') {
      // Get.toNamed(AppRoutes.driverAuthSelectionScreen);
    } else if (selectedRole.value == 'passenger') {
      // Get.toNamed(AppRoutes.passengerAuthSelectionScreen);
    }
  }
}
