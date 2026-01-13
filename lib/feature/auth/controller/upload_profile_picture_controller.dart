import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProfilePictureController extends GetxController {
  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isImageUploading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final RxBool isUploaded = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== Business Logic ====================
  Future<void> uploadAndSelectImage(File image) async {
    try {
      isImageUploading.value = true;
      profileImage.value = image;
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
          profileImageUrl.value = data[0];
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
      isImageUploading.value = false;
    }
  }

  void removeImage() {
    profileImage.value = null;
    profileImageUrl.value = '';
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }
}
