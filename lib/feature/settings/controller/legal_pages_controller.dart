import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/legal_document_model.dart';
import '../service/settings_service.dart';

class LegalPagesController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<LegalDocumentModel?> legalDocument = Rx<LegalDocumentModel?>(null);
  final Rx<LegalDocumentType> documentType = LegalDocumentType.termsAndConditions.obs;

  // ==================== Services ====================
  final SettingsService _settingsService = SettingsService();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    // Get document type from arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      final type = args['type'];
      if (type != null && type is LegalDocumentType) {
        documentType.value = type;
      }
    }
    fetchLegalDocument();
  }

  // ==================== Business Logic ====================
  Future<void> fetchLegalDocument() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _settingsService.getLegalDocument(documentType.value);

      if (response.isSuccess) {
        final legalResponse = LegalDocumentResponse.fromJson(response.responseData);
        if (legalResponse.success && legalResponse.data != null) {
          legalDocument.value = legalResponse.data;
        } else {
          errorMessage.value = legalResponse.message.isNotEmpty
              ? legalResponse.message
              : 'Failed to load document';
        }
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load document';
        Get.snackbar(
          'Error',
          errorMessage.value,
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
      isLoading.value = false;
    }
  }

  // ==================== Getters ====================
  String get title => legalDocument.value?.title ?? _getDefaultTitle();
  String get description => legalDocument.value?.description ?? '';

  String _getDefaultTitle() {
    switch (documentType.value) {
      case LegalDocumentType.privacyPolicy:
        return 'Privacy Policy';
      case LegalDocumentType.termsAndConditions:
        return 'Terms of Service';
      case LegalDocumentType.aboutUs:
        return 'About Us';
    }
  }
}
