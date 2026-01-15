import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/data/forgot_password_request_model.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class EmailValidationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController emailTEController = TextEditingController();

  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPasswordReset = false.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    // Get arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      // Get email from arguments if available
      final email = args['email'];
      if (email != null) {
        emailTEController.text = email;
      }
      // Check if this is for password reset
      isPasswordReset.value = args['isPasswordReset'] ?? false;
    }
  }

  @override
  void onClose() {
    emailTEController.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  Future<void> sendVerificationEmail() async {
    if (!validateEmail()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (isPasswordReset.value) {
        // Call forgot password API
        final request = ForgotPasswordRequestModel(
          email: emailTEController.text.trim(),
        );
        final response = await _authService.forgotPassword(request);

        if (response.isSuccess) {
          isEmailSent.value = true;
          // Navigate to OTP screen with password reset flag
          Get.toNamed(
            AppRoutes.otpVerificationScreen,
            arguments: {
              'email': emailTEController.text.trim(),
              'isPasswordReset': true,
            },
          );
        } else {
          errorMessage.value = response.errorMessage;
          Get.snackbar(
            'Error',
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to send reset email',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // For email verification, just navigate to OTP screen
        // (OTP is sent during signup)
        Get.toNamed(
          AppRoutes.otpVerificationScreen,
          arguments: {
            'email': emailTEController.text.trim(),
            'isPasswordReset': false,
          },
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
  bool validateEmail() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // ==================== Navigation ====================
  void goBack() {
    Get.back();
  }
}
