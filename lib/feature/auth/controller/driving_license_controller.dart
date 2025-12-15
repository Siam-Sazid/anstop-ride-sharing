import 'dart:io';
import 'package:get/get.dart';

class DrivingLicenseController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<File?> frontImage = Rx<File?>(null);
  final Rx<File?> backImage = Rx<File?>(null);
  final RxBool isUploaded = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== Business Logic ====================
  void selectFrontImage(File image) {
    frontImage.value = image;
  }

  void selectBackImage(File image) {
    backImage.value = image;
  }

  void removeFrontImage() {
    frontImage.value = null;
  }

  void removeBackImage() {
    backImage.value = null;
  }

  Future<void> uploadLicense() async {
    if (!validateImages()) {
      errorMessage.value = 'Please select both front and back images';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual license upload API call
      await Future.delayed(const Duration(seconds: 2));

      isUploaded.value = true;

      // Navigate to next document screen
      // Get.back(result: true);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
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
