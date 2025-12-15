import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverProfileController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController phoneTEController = TextEditingController();
  final TextEditingController addressTEController = TextEditingController();
  final TextEditingController birthdayTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString gender = 'male'.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameTEController.dispose();
    emailTEController.dispose();
    phoneTEController.dispose();
    addressTEController.dispose();
    birthdayTEController.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual API call to load profile
      await Future.delayed(const Duration(seconds: 1));

      // For now, set dummy data
      nameTEController.text = '';
      emailTEController.text = '';
      phoneTEController.text = '';
      addressTEController.text = '';
      birthdayTEController.text = '';

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }

  void selectImage(File image) {
    profileImage.value = image;
  }

  void setGender(String value) {
    gender.value = value;
  }

  Future<void> updateProfile() async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual profile update API call
      await Future.delayed(const Duration(seconds: 2));

      isEditing.value = false;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Validation ====================
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
    return null;
  }
}
