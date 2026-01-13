import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrivingLicenseController extends GetxController {
  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== Text Controllers ====================
  final TextEditingController licenseNumberTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isFrontImageUploading = false.obs;
  final RxBool isBackImageUploading = false.obs;
  final Rx<File?> frontImage = Rx<File?>(null);
  final Rx<File?> backImage = Rx<File?>(null);
  final RxString frontImageUrl = ''.obs;
  final RxString backImageUrl = ''.obs;
  final RxBool isUploaded = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    licenseNumberTEController.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  Future<void> uploadAndSelectFrontImage(File image) async {
    try {
      isFrontImageUploading.value = true;
      frontImage.value = image;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        errorMessage.value = 'Access token not found. Please login again.';
        Get.snackbar(
          'Error',
          'Access token not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await _authService.uploadFiles(
        accessToken: accessToken,
        files: [image],
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data != null && data is List && data.isNotEmpty) {
          frontImageUrl.value = data[0];
        } else {
          errorMessage.value = 'Failed to get image URL from response';
          Get.snackbar(
            'Upload Failed',
            'Failed to get image URL from response',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Upload Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to upload image. Please try again.',
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
      isFrontImageUploading.value = false;
    }
  }

  Future<void> uploadAndSelectBackImage(File image) async {
    try {
      isBackImageUploading.value = true;
      backImage.value = image;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        errorMessage.value = 'Access token not found. Please login again.';
        Get.snackbar(
          'Error',
          'Access token not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await _authService.uploadFiles(
        accessToken: accessToken,
        files: [image],
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data != null && data is List && data.isNotEmpty) {
          backImageUrl.value = data[0];
        } else {
          errorMessage.value = 'Failed to get image URL from response';
          Get.snackbar(
            'Upload Failed',
            'Failed to get image URL from response',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Upload Failed',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to upload image. Please try again.',
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
      isBackImageUploading.value = false;
    }
  }

  void removeFrontImage() {
    frontImage.value = null;
    frontImageUrl.value = '';
  }

  void removeBackImage() {
    backImage.value = null;
    backImageUrl.value = '';
  }

  // ==================== Validation ====================
  bool validateImages() {
    return frontImage.value != null && backImage.value != null;
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }

  void skipUpload() {
    // Get.back(result: false);
  }
}
