import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing/l10n/app_localizations.dart';
import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLocationController extends GetxController {
  final TextEditingController locationTEController = TextEditingController();

  // Controllers for GooglePlaceAutoCompleteTextField
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  bool isSubmitting = false;
  Set<Marker> markers = {};

  // Address type from navigation arguments
  String addressType = 'SET_ON_MAP';

  // State to show confirm card (for SET_ON_MAP and BOOKMARK flow)
  bool showConfirmCard = false;

  // Saved location data (used to update map when it's ready)
  double? savedLatitude;
  double? savedLongitude;
  String? savedAddressName;

  // List of saved bookmarks (for BOOKMARK type)
  List<Map<String, dynamic>> savedBookmarks = [];

  // Default location (Dhaka, Bangladesh)
  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  @override
  void onInit() {
    super.onInit();
    // Get address type from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['addressType'] != null) {
      addressType = args['addressType'];
    }

    // For HOME and WORK, show confirm card directly
    if (addressType == 'HOME' || addressType == 'WORK') {
      showConfirmCard = true;
    }

    _initializeMap();
    // Fetch existing address if any
    _fetchExistingAddress();
  }

  // Fetch existing address from API
  Future<void> _fetchExistingAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        return;
      }

      final apiClient = ApiClient();
      final url = '${ApiUrls.baseUrl}/users/address?type=$apiAddressType';

      final response = await apiClient.getRequest(
        url,
        accessToken: accessToken,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        if (data != null) {
          // Check if data is a list (BOOKMARK type) or single object (HOME/WORK)
          if (data is List) {
            // Handle multiple bookmarks
            savedBookmarks = data.map((item) => {
              'name': item['name'] as String? ?? '',
              'coordinates': item['coordinates'] as List<dynamic>? ?? [],
              '_id': item['_id'] as String? ?? '',
            }).toList();
            update();
          } else {
            // Handle single address (HOME/WORK)
            final name = data['name'] as String?;
            final coordinates = data['coordinates'] as List<dynamic>?;

            if (name != null && name.isNotEmpty) {
              addressController.text = name;
            }

            // Note: coordinates array is [longitude, latitude]
            if (coordinates != null && coordinates.length >= 2) {
              final longitude = coordinates[0];
              final latitude = coordinates[1];

              longitudeController.text = longitude.toString();
              latitudeController.text = latitude.toString();

              // Store saved location data
              savedLatitude = latitude.toDouble();
              savedLongitude = longitude.toDouble();
              savedAddressName = name ?? '';

              // Update marker on map (if map is ready)
              _updateMapWithSavedAddress(savedLatitude!, savedLongitude!, savedAddressName!);
            }
          }
        }
      }
    } catch (e) {
      // Silently fail - address might not exist yet
      print('Error fetching existing address: $e');
    }
  }

  // Select a bookmark from the list
  void selectBookmark(int index) {
    if (index >= 0 && index < savedBookmarks.length) {
      final bookmark = savedBookmarks[index];
      final name = bookmark['name'] as String;
      final coordinates = bookmark['coordinates'] as List<dynamic>;

      if (coordinates.length >= 2) {
        final longitude = coordinates[0];
        final latitude = coordinates[1];

        // Populate text fields
        addressController.text = name;
        longitudeController.text = longitude.toString();
        latitudeController.text = latitude.toString();

        // Store saved location data
        savedLatitude = latitude.toDouble();
        savedLongitude = longitude.toDouble();
        savedAddressName = name;

        // Update marker on map
        _updateMapWithSavedAddress(savedLatitude!, savedLongitude!, savedAddressName!);
      }
    }
  }

  // Update map with saved address
  void _updateMapWithSavedAddress(double lat, double lng, String addressName) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('saved_location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: addressName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Move camera to saved location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15.0,
          ),
        ),
      );
    }

    update();
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading = false;
      update();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading = false;
        update();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading = false;
      update();
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition = position;
      isLoading = false;

      // Only add current location marker if we don't have a saved address
      // (saved address takes priority)
      if (savedLatitude == null && savedLongitude == null) {
        final l10n = AppLocalizations.of(Get.context!)!;
        markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: l10n.yourLocationMarker),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        // Move camera to current location (Check if mapController is null)
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15.0,
              ),
            ),
          );
        }
      }

      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // Called when "Set Location" button is tapped (for SET_ON_MAP flow)
  void onSetLocationTapped() {
    if (addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an address from the suggestions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show confirm card
    showConfirmCard = true;
    update();
  }

  // Get the API address type (SET_ON_MAP and BOOKMARK both use BOOKMARK)
  String get apiAddressType {
    if (addressType == 'SET_ON_MAP' || addressType == 'BOOKMARK') {
      return 'BOOKMARK';
    }
    return addressType; // HOME or WORK
  }

  // Check if we should show bookmarks list
  bool get shouldShowBookmarksList {
    return (addressType == 'SET_ON_MAP' || addressType == 'BOOKMARK') &&
           savedBookmarks.isNotEmpty;
  }

  // Get confirm button text based on address type
  String getConfirmButtonText() {
    final l10n = AppLocalizations.of(Get.context!)!;
    switch (addressType) {
      case 'HOME':
        return l10n.confirmHomeAddress;
      case 'WORK':
        return l10n.confirmWorkAddress;
      case 'SET_ON_MAP':
      case 'BOOKMARK':
      default:
        return l10n.confirmBookmark;
    }
  }

  // Called when confirm button is tapped
  Future<void> onConfirmAddressTapped() async {
    if (addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an address from the suggestions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      if (accessToken.isEmpty) {
        Get.snackbar(
          'Error',
          'Please login to continue',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final apiClient = ApiClient();
      final url = '${ApiUrls.baseUrl}/users/address?type=$apiAddressType';

      final body = {
        'name': addressController.text,
        'latitude': double.tryParse(latitudeController.text) ?? 0.0,
        'longitude': double.tryParse(longitudeController.text) ?? 0.0,
      };

      final response = await apiClient.postRequest(
        url,
        body: body,
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Address saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back to previous screen
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to save address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting = false;
      update();
    }
  }

  // Update marker when address is selected
  void updateMarkerFromAddress() {
    final lat = double.tryParse(latitudeController.text);
    final lng = double.tryParse(longitudeController.text);

    if (lat != null && lng != null) {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: addressController.text),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Move camera to selected location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15.0,
            ),
          ),
        );
      }

      update();
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  // This function is called from the GoogleMap widget when the map is created
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // If we have saved location data, apply it now that the map is ready
    if (savedLatitude != null && savedLongitude != null) {
      _updateMapWithSavedAddress(savedLatitude!, savedLongitude!, savedAddressName ?? '');
    }
  }
}

