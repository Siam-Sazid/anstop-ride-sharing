import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_sharing/feature/driver/trip_flow/model/ride_request_model.dart';
import 'package:ride_sharing/services/socket_services.dart';
import 'package:http/http.dart' as http;

class DriverHomeScreenController extends GetxController {
  final Logger _logger = Logger();
  final TextEditingController locationTEController = TextEditingController();
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  Set<Marker> markers = {};

  // Ride request state
  final Rx<RideRequestModel?> currentRideRequest = Rx<RideRequestModel?>(null);
  final RxBool hasNewRideRequest = false.obs;

  // Ride accepted state
  final RxBool isRideAccepted = false.obs;
  final RxString acceptedRideId = ''.obs;
  final RxString acceptedRiderId = ''.obs;

  // Polyline state for navigation
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isNavigatingToPickup = false.obs;
  LatLng? pickupLocation;
  String? pickupName;
  StreamSubscription<Position>? _locationSubscription;

  // Google API Key from manifest
  static const String _googleApiKey = 'AIzaSyCOAYoZktEbWIRX4mbS9D9ypHXdyYWFpSo';


  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
    _setupSocketListeners();
  }

  Future<void> _setupSocketListeners() async {
    try {
      final socketService = SocketIoService.to;

      _logger.i('Setting up socket listeners...');
      _logger.i('Current socket status - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');

      // Connect to socket if not connected
      if (!socketService.isConnected.value) {
        _logger.i('Socket not connected, connecting...');
        await socketService.connect();

        // Wait for connection to establish
        await Future.delayed(const Duration(milliseconds: 500));
        _logger.i('After connect - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');
      }

      // Verify socket is ready before setting up listeners
      if (!socketService.isSocketReady) {
        _logger.w('Socket still not ready, retrying connection...');
        await socketService.connect();
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      if (!socketService.isSocketReady) {
        _logger.e('Socket failed to connect after retry');
        return;
      }

      _logger.i('Socket is ready, setting up listeners');

      // Set up the ride-request listener
      socketService.onRideRequest((data) {
        _logger.i('Ride request received: $data');
        _handleRideRequest(data);
      });

      // Set up the ride-accepted listener
      socketService.onRideAccepted((data) {
        _logger.i('Ride accepted received: $data');
        _handleRideAccepted(data);
      });

      _logger.i('Socket listeners set up successfully - ride-request and ride-accepted');
    } catch (e) {
      _logger.e('Error setting up socket listeners: $e');
    }
  }

  void _handleRideAccepted(dynamic data) {
    try {
      if (data != null && data is Map<String, dynamic>) {
        acceptedRideId.value = data['rideId'] ?? '';
        acceptedRiderId.value = data['riderId'] ?? '';
        isRideAccepted.value = true;

        _logger.i('Ride accepted - rideId: ${acceptedRideId.value}, riderId: ${acceptedRiderId.value}');
        update();
      }
    } catch (e) {
      _logger.e('Error handling ride accepted: $e');
    }
  }

  void clearRideAccepted() {
    isRideAccepted.value = false;
    acceptedRideId.value = '';
    acceptedRiderId.value = '';
    update();
  }

  void _handleRideRequest(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        currentRideRequest.value = RideRequestModel.fromJson(data);
        hasNewRideRequest.value = true;
        _logger.i('Ride request parsed successfully: ${currentRideRequest.value?.rideId}');
        update();
      }
    } catch (e) {
      _logger.e('Error parsing ride request: $e');
    }
  }

  void clearRideRequest() {
    currentRideRequest.value = null;
    hasNewRideRequest.value = false;
    update();
  }

  // Show route to pickup location with polyline
  void showRouteToPickup({
    required double pickupLat,
    required double pickupLng,
    required String pickupName,
  }) {
    _logger.i('Showing route to pickup: $pickupName ($pickupLat, $pickupLng)');

    this.pickupLocation = LatLng(pickupLat, pickupLng);
    this.pickupName = pickupName;
    isNavigatingToPickup.value = true;

    // Add pickup marker
    markers.add(
      Marker(
        markerId: const MarkerId('pickup_location'),
        position: LatLng(pickupLat, pickupLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Pickup', snippet: pickupName),
      ),
    );

    // Get and draw route
    _getRouteToPickup();

    // Start real-time location tracking
    _startLocationTracking();

    // Move camera to show both locations
    _fitBothLocations();

    update();
  }

  Future<void> _getRouteToPickup() async {
    if (currentPosition == null || pickupLocation == null) {
      _logger.e('Cannot get route - missing current position or pickup location');
      return;
    }

    try {
      final origin = '${currentPosition!.latitude},${currentPosition!.longitude}';
      final destination = '${pickupLocation!.latitude},${pickupLocation!.longitude}';

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$origin&destination=$destination&key=$_googleApiKey&mode=driving',
      );

      _logger.i('Fetching route from Google Directions API');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polylinePoints = _decodePolyline(points);

          polylines.value = {
            Polyline(
              polylineId: const PolylineId('route_to_pickup'),
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          };

          _logger.i('Route polyline drawn with ${polylinePoints.length} points');
          update();
        } else {
          _logger.e('No routes found: ${data['status']}');
          // Fallback: draw straight line
          _drawStraightLine();
        }
      } else {
        _logger.e('Directions API error: ${response.statusCode}');
        _drawStraightLine();
      }
    } catch (e) {
      _logger.e('Error fetching route: $e');
      _drawStraightLine();
    }
  }

  // Decode Google's encoded polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;

      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // Fallback: draw straight line if API fails
  void _drawStraightLine() {
    if (currentPosition == null || pickupLocation == null) return;

    polylines.value = {
      Polyline(
        polylineId: const PolylineId('route_to_pickup'),
        points: [
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
          pickupLocation!,
        ],
        color: Colors.blue,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    _logger.i('Drew straight line fallback');
    update();
  }

  void _startLocationTracking() {
    _logger.i('Starting real-time location tracking');

    _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      _logger.i('Location updated: ${position.latitude}, ${position.longitude}');

      currentPosition = position;

      // Update driver marker
      markers.removeWhere((m) => m.markerId.value == 'driver_location');
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );

      // Update route polyline
      if (isNavigatingToPickup.value) {
        _getRouteToPickup();
      }

      update();
    });
  }

  void _fitBothLocations() {
    if (mapController == null || currentPosition == null || pickupLocation == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        currentPosition!.latitude < pickupLocation!.latitude
            ? currentPosition!.latitude
            : pickupLocation!.latitude,
        currentPosition!.longitude < pickupLocation!.longitude
            ? currentPosition!.longitude
            : pickupLocation!.longitude,
      ),
      northeast: LatLng(
        currentPosition!.latitude > pickupLocation!.latitude
            ? currentPosition!.latitude
            : pickupLocation!.latitude,
        currentPosition!.longitude > pickupLocation!.longitude
            ? currentPosition!.longitude
            : pickupLocation!.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void stopNavigation() {
    _logger.i('Stopping navigation');
    isNavigatingToPickup.value = false;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    polylines.clear();
    markers.removeWhere((m) => m.markerId.value == 'pickup_location');
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

      markers = {
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      };

      update(); // markers + position updated
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    _locationSubscription?.cancel();
    // Remove socket listeners
    SocketIoService.to.offRideRequest();
    SocketIoService.to.offRideAccepted();
    super.onClose();
  }
}
