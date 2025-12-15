import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OngoingTripController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<dynamic> trip = Rx<dynamic>(null);
  final Rx<LatLng?> driverLocation = Rx<LatLng?>(null);
  final RxString eta = ''.obs;
  final RxString errorMessage = ''.obs;
  GoogleMapController? mapController;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadTripDetails();
    _trackDriver();
  }

  @override
  void onClose() {
    mapController?.dispose();
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

  void _trackDriver() {
    // TODO: Implement real-time driver location tracking using socket
    // This should update driverLocation and eta
  }

  Future<void> cancelTrip() async {
    try {
      isLoading.value = true;

      // Navigate to cancellation screen
      // final result = await Get.toNamed(AppRoutes.cancelTaxiScreen);

      // if (result == true) {
      //   Get.back();
      // }

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void contactDriver() {
    // TODO: Implement contact driver functionality
    // Could open phone dialer or chat
  }

  void reportIssue() {
    // TODO: Implement report issue functionality
  }
}
