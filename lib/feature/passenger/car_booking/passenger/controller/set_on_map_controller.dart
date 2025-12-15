import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetOnMapController extends GetxController {
  // ==================== Text Controllers ====================
  final TextEditingController searchController = TextEditingController();

  // ==================== State ====================
  final RxBool isLoading = false.obs;
  final RxList<String> recentPlaces = <String>[].obs;
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final RxString selectedAddress = ''.obs;
  GoogleMapController? mapController;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _loadRecentPlaces();
  }

  @override
  void onClose() {
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  // ==================== Business Logic ====================
  void _loadRecentPlaces() {
    // TODO: Load recent places from storage
    recentPlaces.value = [
      'Home',
      'Office',
      'Airport',
    ];
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;

      // TODO: Implement actual location search API call
      await Future.delayed(const Duration(seconds: 1));

      // For now, just set a dummy location
      // selectedLocation.value = LatLng(23.8103, 90.4125);
      // selectedAddress.value = query;

    } catch (e) {
      print('Error searching location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectLocation(LatLng location, String address) {
    selectedLocation.value = location;
    selectedAddress.value = address;

    // Move camera to selected location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(location),
      );
    }
  }

  void confirmLocation() {
    if (selectedLocation.value != null) {
      // Return selected location to previous screen
      // Get.back(result: {
      //   'location': selectedLocation.value,
      //   'address': selectedAddress.value,
      // });
    }
  }

  void clearRecents() {
    recentPlaces.clear();
  }

  // ==================== Navigation ====================
  void goBack() {
    // Get.back();
  }
}
