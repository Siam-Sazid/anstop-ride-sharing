import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:ride_sharing/feature/auth/data/verify_otp_request_model.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController otpController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt timer = 60.obs;
  final RxBool canResend = false.obs;
  final RxString userEmail = ''.obs;
  final RxBool isPasswordReset = false.obs;
  Timer? _countdownTimer;

  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    // Get arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      // Get email from arguments
      final email = args['email'];
      if (email != null) {
        userEmail.value = email;
      }
      // Check if this is for password reset
      isPasswordReset.value = args['isPasswordReset'] ?? false;
    }
    startTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    _countdownTimer?.cancel();
    super.onClose();
  }

  // ==================== Business Logic ====================
  void startTimer() {
    timer.value = 60;
    canResend.value = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer.value > 0) {
        this.timer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty) {
      errorMessage.value = 'Please enter OTP';
      Get.snackbar(
        'Error',
        'Please enter OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (otpController.text.length < 6) {
      errorMessage.value = 'Please enter valid 6-digit OTP';
      Get.snackbar(
        'Error',
        'Please enter valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (userEmail.value.isEmpty) {
      errorMessage.value = 'Email not found';
      Get.snackbar(
        'Error',
        'Email not found. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create verify OTP request model with appropriate type
      final verifyOtpRequest = VerifyOtpRequestModel(
        otp: otpController.text.trim(),
        email: userEmail.value,
        type: isPasswordReset.value
            ? OtpType.passwordReset
            : OtpType.emailVerification,
      );

      // Call verify OTP API
      final response = await _authService.verifyOtp(verifyOtpRequest);

      if (response.isSuccess) {
        if (isPasswordReset.value) {
          // Password reset flow - navigate to passenger home screen
          Get.snackbar(
            'Success',
            'Password reset successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Navigate to passenger home screen
          Get.offAllNamed(AppRoutes.passengerHomeScreen);
        } else {
          // Email verification flow - navigate to login screen
          Get.snackbar(
            'Success',
            'Email verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Navigate to login screen
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      } else {
        // Show error message
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Verification Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Invalid OTP. Please try again.',
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

  Future<void> resendOTP() async {
    if (!canResend.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual resend OTP API call
      await Future.delayed(const Duration(seconds: 1));

      startTimer();

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }
}
