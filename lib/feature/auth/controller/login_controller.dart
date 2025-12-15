import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    super.onClose();
  }

  // ==================== UI Actions ====================
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!validateCredentials()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual login API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Navigate to home based on user role
      // Get.offAllNamed(AppRoutes.passengerHomeScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
  bool validateCredentials() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // ==================== Navigation ====================
  void navigateToForgotPassword() {
    // Get.toNamed(AppRoutes.emailValidationScreen);
  }

  void navigateToSignUp(bool isDriver) {
    // if (isDriver) {
    //   Get.toNamed(AppRoutes.driverRegistrationScreen);
    // } else {
    //   Get.toNamed(AppRoutes.passengerRegistrationScreen);
    // }
  }
}
