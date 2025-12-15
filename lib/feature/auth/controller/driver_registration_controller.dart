import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverRegistrationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController phoneTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isAgreedToTerms = false.obs;
  final RxInt currentStep = 0.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    nameTEController.dispose();
    emailTEController.dispose();
    phoneTEController.dispose();
    passwordTEController.dispose();
    confirmPasswordTEController.dispose();
    super.onClose();
  }

  // ==================== UI Actions ====================
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleTermsAgreement(bool? value) {
    isAgreedToTerms.value = value ?? false;
  }

  void nextStep() {
    if (validateCurrentStep()) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> register() async {
    if (!validateForm()) {
      return;
    }

    if (!isAgreedToTerms.value) {
      errorMessage.value = 'Please agree to terms and conditions';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to document upload screen
      // Get.toNamed(AppRoutes.uploadDocumentsScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
  bool validateCurrentStep() {
    return formKey.currentState?.validate() ?? false;
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
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

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordTEController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ==================== Navigation ====================
  void navigateToLogin() {
    // Get.back();
  }

  void showTermsAndConditions() {
    // TODO: Show terms and conditions
  }
}
