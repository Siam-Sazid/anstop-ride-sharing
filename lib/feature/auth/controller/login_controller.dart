import 'dart:convert';

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
      print("response.statusCode");
      print(response.statusCode);
      if (response.isSuccess) {
        // Parse the response data
        final signInResponse = SignInResponseModel.fromJson(response.responseData);

        // Check if user needs email verification
        if (signInResponse.data.needsVerification) {
          // Navigate to email validation screen with pre-filled email
          Get.toNamed(
            AppRoutes.emailValidationScreen,
            arguments: {'email': emailTEController.text.trim()},
          );

          Get.snackbar(
            'Verification Required',
            'Please verify your email to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        // Validate tokens before proceeding
        if (signInResponse.data.accessToken.isEmpty ||
            signInResponse.data.refreshToken.isEmpty) {
          Get.snackbar(
            'Login Failed',
            'Invalid response from server. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

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

        // Handle navigation based on role
        if (signInResponse.data.role.contains('RIDER')) {
          Get.toNamed(AppRoutes.passengerHomeScreen);
        } else if (signInResponse.data.role.contains('DRIVER')) {
          // Check driver onboarding status
          await _handleDriverNavigation(signInResponse.data.accessToken);
        } else {
          Get.toNamed(AppRoutes.passengerHomeScreen);
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

      // Try to get userId from data first, or decode from JWT token
      String? userId = data.userId;
      if (userId == null || userId.isEmpty) {
        userId = _extractUserIdFromToken(data.accessToken);
      }

      // Save user info for messaging and other features
      if (userId != null && userId.isNotEmpty) {
        await prefs.setString('userId', userId);
      }
      if (data.name != null && data.name!.isNotEmpty) {
        await prefs.setString('name', data.name!);
      }
      if (data.profilePicture != null && data.profilePicture!.isNotEmpty) {
        await prefs.setString('profilePicture', data.profilePicture!);
      }

      // Debug logging
      print('💾 Saved Access Token: ${data.accessToken}');
      print('💾 Saved User Role: ${data.role}');
      print('💾 Saved User ID: $userId');
      print('💾 Saved User Name: ${data.name}');

      // Verify it was saved
      final savedToken = prefs.getString('accessToken');
      print('✅ Verified Saved Token: $savedToken');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Decode JWT token to extract user ID
  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed for base64 decoding
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> data = jsonDecode(decoded);

      return data['_id'] as String?;
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  Future<void> _handleDriverNavigation(String accessToken) async {
    try {
      // Call onboarding status API
      final onboardingResponse = await _authService.getDriverOnboardingStatus(
        accessToken: accessToken,
      );

      if (onboardingResponse.isSuccess) {
        // Check if driver is onboarded
        final isOnboarded = onboardingResponse.responseData['data']?['isOnboarded'] ?? false;

        if (isOnboarded) {
          // Driver is fully onboarded, go to driver home screen
          Get.toNamed(AppRoutes.driverHomeScreen);
        } else {
          // Driver needs to complete onboarding
          Get.toNamed(AppRoutes.driverRegistrationScreen);
        }
      } else {
        // If onboarding status check fails, assume not onboarded
        Get.toNamed(AppRoutes.driverRegistrationScreen);
      }
    } catch (e) {
      print('Error checking driver onboarding status: $e');
      // On error, default to registration screen
      Get.toNamed(AppRoutes.driverRegistrationScreen);
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
    Get.toNamed(
      AppRoutes.emailValidationScreen,
      arguments: {'isPasswordReset': true},
    );
  }

  void navigateToSignUp(bool isDriver) {
    // if (isDriver) {
    //   Get.toNamed(AppRoutes.driverRegistrationScreen);
    // } else {
    //   Get.toNamed(AppRoutes.passengerRegistrationScreen);
    // }
  }
}
