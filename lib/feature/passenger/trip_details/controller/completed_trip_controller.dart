import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedTripController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController reviewTEController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<dynamic> trip = Rx<dynamic>(null);
  final RxDouble rating = 0.0.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasSubmittedRating = false.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadTripDetails();
  }

  @override
  void onClose() {
    reviewTEController.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  Future<void> _loadTripDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual API call to load trip details
      await Future.delayed(const Duration(seconds: 1));

      // Get trip data from arguments if passed
      if (Get.arguments != null) {
        trip.value = Get.arguments;
      }

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setRating(double value) {
    rating.value = value;
  }

  Future<void> submitRating() async {
    if (rating.value == 0) {
      errorMessage.value = 'Please provide a rating';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Implement actual rating submission API call
      await Future.delayed(const Duration(seconds: 1));

      hasSubmittedRating.value = true;

      // Show success message
      Get.snackbar(
        'Success',
        'Thank you for your feedback!',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadReceipt() async {
    try {
      isLoading.value = true;

      // TODO: Implement receipt download
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Receipt downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void reportIssue() {
    // TODO: Navigate to report screen
  }
}
