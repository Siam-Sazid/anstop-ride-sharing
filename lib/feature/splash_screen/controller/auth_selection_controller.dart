import 'package:get/get.dart';

class AuthSelectionController extends GetxController {
  // ==================== State ====================
  final RxString authType = ''.obs;
  final RxString userRole = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    // Get role from arguments if passed
    if (Get.arguments != null) {
      userRole.value = Get.arguments as String? ?? '';
    }
  }

  // ==================== Business Logic ====================
  void selectAuthType(String type) {
    authType.value = type;
  }

  void navigateToLogin() {
    // Get.toNamed(AppRoutes.loginScreen);
  }

  void navigateToSignUp() {
    if (userRole.value == 'driver') {
      // Get.toNamed(AppRoutes.driverRegistrationScreen);
    } else {
      // Get.toNamed(AppRoutes.passengerRegistrationScreen);
    }
  }

  void navigate(String destination) {
    if (destination == 'login') {
      navigateToLogin();
    } else if (destination == 'signup') {
      navigateToSignUp();
    }
  }
}
