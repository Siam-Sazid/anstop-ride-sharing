import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/data/signin_request_model.dart';
import 'package:ride_sharing/feature/auth/data/signin_response_model.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:ride_sharing/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Services ====================
  final AuthService _authService = AuthService();

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

      // Create signin request model
      final signInRequest = SignInRequestModel(
        email: emailTEController.text.trim(),
        password: passwordTEController.text.trim(),
      );

      // Call signin API
      final response = await _authService.signIn(signInRequest);

      if (response.isSuccess) {
        // Parse the response data
        final signInResponse = SignInResponseModel.fromJson(response.responseData);

        // Save tokens and user data to shared preferences
        await _saveUserData(signInResponse.data);

        // Show success message
        // Get.snackbar(
        //   'Success',
        //   signInResponse.message,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );

        // Navigate based on role
        if (signInResponse.data.role.contains('RIDER')) {
          // Navigate to passenger home screen
          Get.offAllNamed(AppRoutes.passengerHomeScreen);
        } else if (signInResponse.data.role.contains('DRIVER')) {
          // Navigate to upload documents screen for drivers
          Get.offAllNamed(AppRoutes.uploadDocumentsScreen);
        } else {
          // Default navigation
          Get.offAllNamed(AppRoutes.passengerHomeScreen);
        }
      } else {
        // Show error message
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Login Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Invalid email or password',
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

  // ==================== Helper Methods ====================
  Future<void> _saveUserData(SignInData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data.accessToken);
      await prefs.setString('refreshToken', data.refreshToken);
      await prefs.setStringList('userRole', data.role);
      await prefs.setBool('needsVerification', data.needsVerification);
    } catch (e) {
      print('Error saving user data: $e');
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
