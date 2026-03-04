import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_sharing/feature/passenger/car_booking/service/ride_request_service.dart';

import '../../../../../l10n/app_localizations.dart';

class PickUpLocationController extends GetxController {
  final TextEditingController locationTEController = TextEditingController();

  // Pickup location controllers
  final TextEditingController pickUpAddressController = TextEditingController();
  final TextEditingController pickUpLatitudeController = TextEditingController();
  final TextEditingController pickUpLongitudeController = TextEditingController();

  // Destination location controllers
  final TextEditingController destinationAddressController = TextEditingController();
  final TextEditingController destinationLatitudeController = TextEditingController();
  final TextEditingController destinationLongitudeController = TextEditingController();

  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  bool isCalculatingFare = false;
  Set<Marker> markers = {};

  // Fare, distance and duration (all returned by the calculateFare API)
  double calculatedDistance = 0.0;
  double calculatedFare = 0.0;
  double calculatedDuration = 0.0;

  // Ride for
  String rideFor = 'SELF';
  final TextEditingController friendPhoneController = TextEditingController();

  void setRideFor(String value) {
    rideFor = value;
    update();
  }

  final RideRequestService _rideRequestService = RideRequestService();

  // Default location (Dhaka, Bangladesh)
  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
     debugTestGoogleApiKey(); // Uncomment to debug Google API key issues
  }

  /// Debug method: directly calls Google Places API and logs the raw response
  Future<void> debugTestGoogleApiKey() async {
    const apiKey = "AIzaSyD_NVUY504HfMBsvN1gACNyfaFKAulvkVI"; // This is the api key for my client.
  //  const apiKey = "AIzaSyBUHqcmvmiPPwuwl33JkMP3lAzKMxREenI"; // This is another key for testing purposes.
    const testInput = "Dhaka";
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$testInput&key=$apiKey",
    );

    try {
      final response = await http.get(url);
      debugPrint("===== GOOGLE PLACES API DEBUG =====");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("===================================");

      final decoded = jsonDecode(response.body);
      if (decoded['status'] != 'OK') {
        debugPrint("API Error Status: ${decoded['status']}");
        debugPrint("Error Message: ${decoded['error_message'] ?? 'No error message'}");
      }
    } catch (e) {
      debugPrint("===== GOOGLE PLACES API DEBUG ERROR =====");
      debugPrint("Exception: $e");
      debugPrint("==========================================");
    }
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

      // Pre-fill pickup with current GPS location as default
      pickUpLatitudeController.text = position.latitude.toString();
      pickUpLongitudeController.text = position.longitude.toString();

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [p.name, p.street, p.locality]
              .where((s) => s != null && s.isNotEmpty)
              .toSet()
              .toList();
          pickUpAddressController.text = parts.isNotEmpty
              ? parts.join(', ')
              : 'Current Location';
        } else {
          pickUpAddressController.text = 'Current Location';
        }
      } catch (_) {
        pickUpAddressController.text = 'Current Location';
      }

      final l10n = AppLocalizations.of(Get.context!)!;
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: AppLocalization.tr.yourLocationMarker),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      update();

      // Move camera to current location
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
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double calculateDistanceInKm(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return double.parse(distance.toStringAsFixed(1));
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Check if both locations are set
  bool areLocationsSet() {
    return pickUpLatitudeController.text.isNotEmpty &&
        pickUpLongitudeController.text.isNotEmpty &&
        destinationLatitudeController.text.isNotEmpty &&
        destinationLongitudeController.text.isNotEmpty;
  }

  // Calculate fare from API
  Future<bool> calculateFare() async {
    if (!areLocationsSet()) {
      Get.snackbar(
        'Error',
        'Please select both pickup and destination locations',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isCalculatingFare = true;
    update();

    try {
      final double pickUpLat = double.parse(pickUpLatitudeController.text);
      final double pickUpLng = double.parse(pickUpLongitudeController.text);
      final double destLat = double.parse(destinationLatitudeController.text);
      final double destLng = double.parse(destinationLongitudeController.text);

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final response = await _rideRequestService.calculateFare(
        pickUpLat: pickUpLat,
        pickUpLng: pickUpLng,
        destinationLat: destLat,
        destinationLng: destLng,
        accessToken: accessToken,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData['data'];
        calculatedFare = (data['fare'] as num).toDouble();
        calculatedDistance = (data['distance'] as num).toDouble();
        calculatedDuration = (data['duration'] as num).toDouble();
        isCalculatingFare = false;
        update();
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to calculate fare',
          snackPosition: SnackPosition.BOTTOM,
        );
        isCalculatingFare = false;
        update();
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to calculate fare: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isCalculatingFare = false;
      update();
      return false;
    }
  }

  // Create ride request
  Future<bool> createRideRequest({
    required double preferedFare,
    required String note,
    required List<String> rideNeeds,
    required String paymentMethod,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final body = {
        'pickUp': {
          'name': pickUpAddressController.text,
          // 'latitude': 0,
          // 'longitude': 0
          'latitude': double.parse(pickUpLatitudeController.text),
          'longitude': double.parse(pickUpLongitudeController.text),
        },
        'destination': {
          'name': destinationAddressController.text,
          'latitude': double.parse(destinationLatitudeController.text),
          'longitude': double.parse(destinationLongitudeController.text),
        },
       // 'distance': calculatedDistance.toString(),
       // 'baseFare': calculatedFare,
       // 'preferedFare': preferedFare,
        'note': note,
        'rideNeeds': rideNeeds,
        'paymentMethod': paymentMethod,
        'rideFor': rideFor,
        if (rideFor == 'OTHER') 'riderNumber': friendPhoneController.text,
      };

      final response = await _rideRequestService.createRideRequest(
        body: body,
        accessToken: accessToken,
      );

      if (response.isSuccess) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to create ride request',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create ride request: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Update markers on map
  void updateMapMarkers() {
    markers.clear();

    if (pickUpLatitudeController.text.isNotEmpty && pickUpLongitudeController.text.isNotEmpty) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup_location'),
          position: LatLng(
            double.parse(pickUpLatitudeController.text),
            double.parse(pickUpLongitudeController.text),
          ),
          infoWindow: InfoWindow(title: 'Pickup: ${pickUpAddressController.text}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (destinationLatitudeController.text.isNotEmpty && destinationLongitudeController.text.isNotEmpty) {
      markers.add(
        Marker(
          markerId: MarkerId('destination_location'),
          position: LatLng(
            double.parse(destinationLatitudeController.text),
            double.parse(destinationLongitudeController.text),
          ),
          infoWindow: InfoWindow(title: 'Destination: ${destinationAddressController.text}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    update();
  }

  @override
  void onClose() {
    mapController?.dispose();
    pickUpAddressController.dispose();
    pickUpLatitudeController.dispose();
    pickUpLongitudeController.dispose();
    destinationAddressController.dispose();
    destinationLatitudeController.dispose();
    destinationLongitudeController.dispose();
    friendPhoneController.dispose();
    super.onClose();
  }
}
