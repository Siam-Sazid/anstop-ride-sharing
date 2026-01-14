import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing/feature/passenger/trip_details/data/get_trip_details_model.dart';
import 'package:ride_sharing/feature/passenger/trip_details/service/trip_details_service.dart';

class OngoingTripController extends GetxController {
  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final Rx<TripDetailsData?> trip = Rx<TripDetailsData?>(null);
  final Rx<LatLng?> driverLocation = Rx<LatLng?>(null);
  final RxString eta = ''.obs;
  final RxString errorMessage = ''.obs;
  GoogleMapController? mapController;

  // ==================== Services ====================
  final TripDetailsService _tripDetailsService = TripDetailsService();

  // ==================== Parameters ====================
  final String rideId;

  // ==================== Constructor ====================
  OngoingTripController({required this.rideId});

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

      // Call API to get trip details
      final response = await _tripDetailsService.getTripDetails(rideId);

      if (response.isSuccess) {
        // Parse the trip details from response
        final tripDetailsModel = GetTripDetailsModel.fromJson(response.responseData);
        trip.value = tripDetailsModel.data;
      } else {
        errorMessage.value = response.errorMessage;
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load trip details',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'An error occurred while loading trip details',
        snackPosition: SnackPosition.BOTTOM,
      );
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
