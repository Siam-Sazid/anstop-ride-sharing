import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarInformationController extends GetxController {
  // ==================== Services ====================
  final AuthService _authService = AuthService();

  // ==================== Text Controllers ====================
  final TextEditingController carBrandTEController = TextEditingController();
  final TextEditingController carModelTEController = TextEditingController();
  final TextEditingController carYearTEController = TextEditingController();
  final TextEditingController licensePlateNumberTEController = TextEditingController();
  final TextEditingController registrationCertNumberTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isLicensePlateImageUploading = false.obs;
  final RxBool isRegCertFrontImageUploading = false.obs;
  final RxBool isRegCertBackImageUploading = false.obs;
  final RxString errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  // Images
  final Rx<File?> licensePlateImage = Rx<File?>(null);
  final Rx<File?> regCertFrontImage = Rx<File?>(null);
  final Rx<File?> regCertBackImage = Rx<File?>(null);

  // Image URLs
  final RxString licensePlateImageUrl = ''.obs;
  final RxString regCertFrontImageUrl = ''.obs;
  final RxString regCertBackImageUrl = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    carBrandTEController.dispose();
    carModelTEController.dispose();
    carYearTEController.dispose();
    licensePlateNumberTEController.dispose();
    registrationCertNumberTEController.dispose();
    super.onClose();
  }

  // ==================== Image Selection ====================
  Future<void> uploadAndSelectLicensePlateImage(File image) async {
    try {
      isLicensePlateImageUploading.value = true;
      licensePlateImage.value = image;
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
          licensePlateImageUrl.value = data[0];
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
      isLicensePlateImageUploading.value = false;
    }
  }

  Future<void> uploadAndSelectRegCertFrontImage(File image) async {
    try {
      isRegCertFrontImageUploading.value = true;
      regCertFrontImage.value = image;
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
          regCertFrontImageUrl.value = data[0];
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
      isRegCertFrontImageUploading.value = false;
    }
  }

  Future<void> uploadAndSelectRegCertBackImage(File image) async {
    try {
      isRegCertBackImageUploading.value = true;
      regCertBackImage.value = image;
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
          regCertBackImageUrl.value = data[0];
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
      isRegCertBackImageUploading.value = false;
    }
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
