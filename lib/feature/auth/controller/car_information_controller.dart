import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarInformationController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController carModelTEController = TextEditingController();
  final TextEditingController carNumberTEController = TextEditingController();
  final TextEditingController carColorTEController = TextEditingController();
  final TextEditingController carYearTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    carModelTEController.dispose();
    carNumberTEController.dispose();
    carColorTEController.dispose();
    carYearTEController.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  Future<void> submitCarInfo() async {
    if (!validateCarDetails()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual car info submission API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen
      // Get.toNamed(AppRoutes.uploadProfilePictureScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
  bool validateCarDetails() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateCarModel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car model is required';
    }
    return null;
  }

  String? validateCarNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car number is required';
    }
    return null;
  }

  String? validateCarColor(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car color is required';
    }
    return null;
  }

  String? validateCarYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Car year is required';
    }
    if (int.tryParse(value) == null) {
      return 'Enter a valid year';
    }
    return null;
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }
}
