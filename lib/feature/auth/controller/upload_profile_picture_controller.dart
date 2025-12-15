import 'dart:io';
import 'package:get/get.dart';

class UploadProfilePictureController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isUploaded = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== Business Logic ====================
  void selectImage(File image) {
    profileImage.value = image;
  }

  void removeImage() {
    profileImage.value = null;
  }

  Future<void> uploadImage() async {
    if (profileImage.value == null) {
      errorMessage.value = 'Please select a profile picture';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual image upload API call
      await Future.delayed(const Duration(seconds: 2));

      isUploaded.value = true;

      // Navigate to home screen
      // Get.offAllNamed(AppRoutes.driverHomeScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipUpload() async {
    // Navigate to home screen without uploading
    // Get.offAllNamed(AppRoutes.driverHomeScreen);
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }
}
