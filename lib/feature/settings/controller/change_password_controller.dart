import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/change_password_request_model.dart';
import '../data/change_password_response_model.dart';
import '../service/settings_service.dart';

class ChangePasswordController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController currentPasswordTEController = TextEditingController();
  final TextEditingController newPasswordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController = TextEditingController();

  // ==================== Services ====================
  final SettingsService _settingsService = SettingsService();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscureCurrentPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onClose() {
    currentPasswordTEController.dispose();
    newPasswordTEController.dispose();
    confirmPasswordTEController.dispose();
    super.onClose();
  }

  // ==================== UI Actions ====================
  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<bool> changePassword() async {
    if (!validatePasswords()) {
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final request = ChangePasswordRequestModel(
        currentPassword: currentPasswordTEController.text.trim(),
        newPassword: newPasswordTEController.text.trim(),
        confirmPassword: confirmPasswordTEController.text.trim(),
      );

      final response = await _settingsService.changePassword(request);

      if (response.isSuccess) {
        final changePasswordResponse = ChangePasswordResponseModel.fromJson(
          response.responseData,
        );
        successMessage.value = changePasswordResponse.message.isNotEmpty
            ? changePasswordResponse.message
            : 'Password changed successfully';
        return true;
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to change password';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
  bool validatePasswords() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == currentPasswordTEController.text) {
      return 'New password must be different from current password';
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
