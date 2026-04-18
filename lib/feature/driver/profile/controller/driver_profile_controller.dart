import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_sharing/feature/driver/profile/service/driver_profile_service.dart';
import 'package:ride_sharing/feature/driver/profile/data/user_profile_model.dart';

class DriverProfileController extends GetxController {
  // ==================== Services ====================
  final DriverProfileService _profileService = DriverProfileService();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserProfileData?> profileData = Rx<UserProfileData?>(null);
  final RxBool isAccountInactive = false.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ==================== Business Logic ====================
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        errorMessage.value = 'Not authenticated';
        return;
      }

      final response = await _profileService.getMyProfile(accessToken: accessToken);

      if (response.isSuccess) {
        final profileResponse = UserProfileResponse.fromJson(response.responseData);
        profileData.value = profileResponse.data;
      } else {
        errorMessage.value = response.errorMessage;
        if (response.statusCode == 401) {
          isAccountInactive.value = true;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
