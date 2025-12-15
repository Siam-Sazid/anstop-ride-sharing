import 'package:get/get.dart';

class ChangeLanguageController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxString errorMessage = ''.obs;

  final List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
  ];

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadCurrentLanguage();
  }

  // ==================== Business Logic ====================
  void _loadCurrentLanguage() {
    // TODO: Load saved language preference
    selectedLanguage.value = 'en';
  }

  void selectLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  Future<void> updateLocale() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Update locale in GetX
      // await Get.updateLocale(Locale(selectedLanguage.value));

      // Save preference
      await savePreference();

      Get.snackbar(
        'Success',
        'Language updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Go back
      // Get.back();

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePreference() async {
    // TODO: Save language preference to storage
    await Future.delayed(const Duration(milliseconds: 500));
  }

  String getLanguageName(String code) {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    );
    return language['nativeName'] ?? 'English';
  }
}
