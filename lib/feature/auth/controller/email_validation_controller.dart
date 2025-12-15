import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailValidationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController emailTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;
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

      // TODO: Implement actual email verification API call
      await Future.delayed(const Duration(seconds: 2));

      isEmailSent.value = true;

      // Navigate to OTP screen
      // Get.toNamed(AppRoutes.otpVerificationScreen);

    } catch (e) {
      errorMessage.value = e.toString();
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
    // Get.back();
  }
}
