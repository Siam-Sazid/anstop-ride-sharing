import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController newPasswordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    newPasswordTEController.dispose();
    confirmPasswordTEController.dispose();
    super.onClose();
  }

  // ==================== UI Actions ====================
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> resetPassword() async {
    if (!validatePasswords()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual password reset API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Navigate to login screen
      // Get.offAllNamed(AppRoutes.loginScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
  bool validatePasswords() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != newPasswordTEController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
