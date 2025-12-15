import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class OtpVerificationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController otpController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt timer = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _countdownTimer;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
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
      return;
    }

    if (otpController.text.length < 4) {
      errorMessage.value = 'Please enter valid OTP';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual OTP verification API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Navigate to appropriate screen
      // Get.offAllNamed(AppRoutes.resetPasswordScreen);

    } catch (e) {
      errorMessage.value = e.toString();
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
