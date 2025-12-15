import 'package:get/get.dart';

class SettingsController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<dynamic> user = Rx<dynamic>(null);
  final RxMap<String, bool> preferences = <String, bool>{}.obs;
  final RxString errorMessage = ''.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // ==================== Business Logic ====================
  void _loadUserData() {
    // TODO: Load user data and preferences
    preferences.value = {
      'notifications': true,
      'locationSharing': true,
      'soundEffects': true,
    };
  }

  void navigateToSetting(String settingType) {
    switch (settingType) {
      case 'changePassword':
        // Get.toNamed(AppRoutes.changePasswordScreen);
        break;
      case 'changeLanguage':
        // Get.toNamed(AppRoutes.changeLanguageScreen);
        break;
      case 'profile':
        // Navigate to profile based on user role
        break;
      default:
        break;
    }
  }

  void togglePreference(String key, bool value) {
    preferences[key] = value;
    // TODO: Save preference to storage/API
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // TODO: Implement logout API call
      await Future.delayed(const Duration(seconds: 1));

      // Clear user data and navigate to login
      // Get.offAllNamed(AppRoutes.loginScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      // TODO: Implement delete account API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to login
      // Get.offAllNamed(AppRoutes.loginScreen);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
