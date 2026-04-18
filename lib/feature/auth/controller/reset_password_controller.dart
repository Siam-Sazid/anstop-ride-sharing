import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/data/reset_password_request_model.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController newPasswordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString resetToken = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      userEmail.value = args['email'] ?? '';
      resetToken.value = args['resetToken'] ?? '';
    }
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
    if (!validatePasswords()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = ResetPasswordRequestModel(
        password: newPasswordTEController.text.trim(),
      );

      final response = await _authService.resetPassword(
        request,
        accessToken: resetToken.value.isNotEmpty ? resetToken.value : null,
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Password reset successfully. Please log in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to reset password. Please try again.';
        Get.snackbar(
          'Reset Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
