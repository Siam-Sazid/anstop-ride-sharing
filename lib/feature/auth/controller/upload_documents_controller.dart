import 'package:get/get.dart';

class UploadDocumentsController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxBool isNationalIdUploaded = false.obs;
  final RxBool isDrivingLicenseUploaded = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== Business Logic ====================
  void navigateToDocument(String documentType) {
    switch (documentType) {
      case 'national_id':
        // Get.toNamed(AppRoutes.nationalIdScreen);
        break;
      case 'driving_license':
        // Get.toNamed(AppRoutes.drivingLicenseScreen);
        break;
      default:
        break;
    }
  }

  void markDocumentUploaded(String documentType, bool uploaded) {
    switch (documentType) {
      case 'national_id':
        isNationalIdUploaded.value = uploaded;
        break;
      case 'driving_license':
        isDrivingLicenseUploaded.value = uploaded;
        break;
      default:
        break;
    }
  }

  bool checkCompletion() {
    return isNationalIdUploaded.value && isDrivingLicenseUploaded.value;
  }

  void proceedToNext() {
    if (checkCompletion()) {
      // Get.toNamed(AppRoutes.carInformationScreen);
    } else {
      errorMessage.value = 'Please upload all required documents';
    }
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }

  void skipDocuments() {
    // Get.toNamed(AppRoutes.carInformationScreen);
  }
}
