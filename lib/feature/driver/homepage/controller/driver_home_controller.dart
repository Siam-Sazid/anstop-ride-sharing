import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
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

  // Ride picked up state (after driver confirms pickup)
  final RxBool isRidePickedUp = false.obs;

  // Polyline state for navigation
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isNavigatingToPickup = false.obs;
  LatLng? pickupLocation;
  String? pickupName;
  LatLng? destinationLocation;
  String? destinationName;
  StreamSubscription<Position>? _locationSubscription;

  // Route tracking for snap-to-route and rotation
  List<LatLng> _currentRoutePoints = [];
  double _currentBearing = 0.0;
  int _currentRouteSegmentIndex = 0;

  // Simulation mode for testing/demo
  final RxBool isSimulationMode = false.obs;
  Timer? _simulationTimer;
  int _simulationPointIndex = 0;
  double _simulationProgress = 0.0; // 0.0 to 1.0 between two points
  static const double _simulationSpeed = 0.05; // Progress per tick (adjust for speed)
  static const int _simulationIntervalMs = 50; // Timer interval in milliseconds

  // Google API Key from manifest
  static const String _googleApiKey = 'AIzaSyBUHqcmvmiPPwuwl33JkMP3lAzKMxREenI';

  // Custom markers
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _driverMarkerIcon;

  // Store original car image for rotation
  ui.Image? _carImage;
  int _carImageSize = 80;

  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarkers();
    _initializeMap();
    _setupSocketListeners();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      _pickupMarkerIcon = await _getBitmapDescriptorFromAsset(
        'assets/images/location_pin.png',
        50, // width
      );
      _logger.i('Pickup marker icon loaded');

      // Load and store the car image for rotation
      _carImage = await _loadCarImage('assets/images/3D_car.png', _carImageSize);
      _driverMarkerIcon = await _getRotatedCarBitmap(0); // Initial rotation 0
      _logger.i('Driver marker icon loaded');

      _logger.i('Custom markers loaded successfully');

      // Update markers if they already exist
      if (markers.isNotEmpty && currentPosition != null) {
        await _updateDriverMarker();
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading custom markers: $e');
      _logger.e('Stack trace: $stackTrace');
    }
  }

  // Load car image and store it for rotation
  Future<ui.Image> _loadCarImage(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  // Create a rotated bitmap descriptor from the car image
  Future<BitmapDescriptor> _getRotatedCarBitmap(double rotationDegrees) async {
    _logger.i('_getRotatedCarBitmap called with rotation: ${rotationDegrees.toStringAsFixed(1)}°');

    if (_carImage == null) {
      _logger.e('Car image is null! Cannot rotate.');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }

    final int imageWidth = _carImage!.width;
    final int imageHeight = _carImage!.height;

    // Calculate the size needed for the rotated image (diagonal of original)
    final double diagonal = math.sqrt(imageWidth * imageWidth + imageHeight * imageHeight);
    final int canvasSize = diagonal.ceil();

    // Remove the +90 test offset once rotation is confirmed working
    final double finalRotation = rotationDegrees; // Use actual bearing

    final double rotationRadians = finalRotation * math.pi / 180;

    _logger.i('Car image: ${imageWidth}x$imageHeight, canvas: $canvasSize, rotation: ${finalRotation.toStringAsFixed(1)}°');

    // Create a picture recorder and canvas
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasSize.toDouble(), canvasSize.toDouble()));

    // Calculate center offset
    final double centerX = canvasSize / 2.0;
    final double centerY = canvasSize / 2.0;

    // Save canvas state
    canvas.save();

    // Move to center of canvas
    canvas.translate(centerX, centerY);

    // Rotate around center
    canvas.rotate(rotationRadians);

    // Draw image centered at origin (which is now the center of canvas, rotated)
    canvas.drawImage(
      _carImage!,
      Offset(-imageWidth / 2.0, -imageHeight / 2.0),
      Paint()..filterQuality = FilterQuality.high,
    );

    // Restore canvas state
    canvas.restore();

    // Convert to image
    final ui.Picture picture = recorder.endRecording();
    final ui.Image rotatedImage = await picture.toImage(canvasSize, canvasSize);
    final ByteData? byteData = await rotatedImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      _logger.e('Failed to get byte data from rotated image');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }

    _logger.i('Rotated bitmap SUCCESS - size: $canvasSize, bytes: ${byteData.lengthInBytes}');
    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();
    return BitmapDescriptor.bytes(resizedImageData);
  }

  Future<void> _updateDriverMarker() async {
    if (currentPosition == null) return;

    // Get rotated car bitmap based on current bearing
    final rotatedIcon = await _getRotatedCarBitmap(_currentBearing);

    markers.removeWhere((m) => m.markerId.value == 'driver_location');
    markers.add(
      Marker(
        markerId: const MarkerId('driver_location'),
        position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        icon: rotatedIcon,
        infoWindow: const InfoWindow(title: 'You'),
        anchor: const Offset(0.5, 0.5),
        flat: true,
      ),
    );
    update();
  }

  // Calculate bearing (angle) between two points in degrees
  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lat2 = to.latitude * math.pi / 180;
    final diffLng = (to.longitude - from.longitude) * math.pi / 180;

    final x = math.sin(diffLng) * math.cos(lat2);
    final y = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(diffLng);

    final bearing = math.atan2(x, y);
    return (bearing * 180 / math.pi + 360) % 360;
  }

  // Find the closest point on the route and return snapped position with bearing
  ({LatLng position, double bearing, int segmentIndex}) _snapToRouteWithBearing(LatLng currentPosition) {
    if (_currentRoutePoints.isEmpty) {
      return (position: currentPosition, bearing: _currentBearing, segmentIndex: 0);
    }

    double minDistance = double.infinity;
    LatLng closestPoint = currentPosition;
    int closestSegmentIndex = _currentRouteSegmentIndex;

    // Search from current segment onwards (driver moves forward)
    // Also check a few segments back in case of GPS drift
    final startIndex = math.max(0, _currentRouteSegmentIndex - 2);

    for (int i = startIndex; i < _currentRoutePoints.length; i++) {
      final point = _currentRoutePoints[i];
      final distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        point.latitude,
        point.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
        closestSegmentIndex = i;
      }
    }

    // Calculate bearing to next point on route
    double bearing = _currentBearing;
    if (closestSegmentIndex < _currentRoutePoints.length - 1) {
      bearing = _calculateBearing(
        closestPoint,
        _currentRoutePoints[closestSegmentIndex + 1],
      );
    }

    _logger.i('Snapped to route point $closestSegmentIndex, distance: ${minDistance.toStringAsFixed(1)}m, bearing: ${bearing.toStringAsFixed(1)}°');

    return (position: closestPoint, bearing: bearing, segmentIndex: closestSegmentIndex);
  }

  // Update driver marker with position and rotated bitmap
  Future<void> _updateDriverMarkerWithRotation(LatLng position, double bearing) async {
    // Get rotated car bitmap
    final rotatedIcon = await _getRotatedCarBitmap(bearing);

    // Create a new marker
    final newMarker = Marker(
      markerId: const MarkerId('driver_location'),
      position: position,
      icon: rotatedIcon,
      infoWindow: const InfoWindow(title: 'You'),
      anchor: const Offset(0.5, 0.5),
      flat: true,
    );

    // Create a new Set to ensure Google Maps detects the change
    final updatedMarkers = markers.where((m) => m.markerId.value != 'driver_location').toSet();
    updatedMarkers.add(newMarker);
    markers = updatedMarkers;

    _logger.i('Marker updated with bearing: ${bearing.toStringAsFixed(1)}°, icon hash: ${rotatedIcon.hashCode}');
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

      // Set up the ride-picked-up listener
      socketService.onRidePickedUp((data) {
        _logger.i('Ride picked up received: $data');
        _handleRidePickedUp(data);
      });

      _logger.i('Socket listeners set up successfully - ride-request, ride-accepted, and ride-picked-up');
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

  void clearRidePickedUp() {
    isRidePickedUp.value = false;
    update();
  }

  void _handleRideRequest(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        currentRideRequest.value = RideRequestModel.fromJson(data);
        hasNewRideRequest.value = true;

        // Store destination location for later use (when ride-picked-up is received)
        final destination = currentRideRequest.value!.destination;
        destinationLocation = LatLng(destination.latitude, destination.longitude);
        destinationName = destination.name;
        _logger.i('Stored destination: $destinationName at [${destination.longitude}, ${destination.latitude}]');

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

  Future<void> _handleRidePickedUp(dynamic data) async {
    try {
      _logger.i('Handling ride-picked-up event');

      // Set ride picked up state - this will trigger DriverTripController to show DropOffNavigationBottomSheet
      isRidePickedUp.value = true;

      // Use stored destination location (stored when ride-request was received)
      if (destinationLocation != null && destinationName != null) {
        _logger.i('Using stored destination: $destinationName at [${destinationLocation!.longitude}, ${destinationLocation!.latitude}]');

        // Show route from pickup to destination - AWAIT this
        await showRouteToDestination(
          destinationLat: destinationLocation!.latitude,
          destinationLng: destinationLocation!.longitude,
          destinationName: destinationName!,
        );
      } else {
        _logger.e('No destination location stored - cannot show route');
      }
    } catch (e) {
      _logger.e('Error handling ride picked up: $e');
    }
  }

  // Show route from pickup location to destination with polyline
  Future<void> showRouteToDestination({
    required double destinationLat,
    required double destinationLng,
    required String destinationName,
  }) async {
    _logger.i('showRouteToDestination called - destinationLat: $destinationLat, destinationLng: $destinationLng, destinationName: $destinationName');

    // Use the static pickup location that was used earlier
    if (pickupLocation == null) {
      _logger.e('No pickup location set - cannot show route to destination');
      // Set default pickup location
      pickupLocation = const LatLng(23.73439856033021, 90.40467599770942);
    }

    destinationLocation = LatLng(destinationLat, destinationLng);
    this.destinationName = destinationName;

    // Reset route tracking for new route
    _currentRoutePoints = [];
    _currentRouteSegmentIndex = 0;

    // Add destination marker
    markers.removeWhere((m) => m.markerId.value == 'destination_location');
    markers.add(
      Marker(
        markerId: const MarkerId('destination_location'),
        position: LatLng(destinationLat, destinationLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Destination', snippet: destinationName),
      ),
    );
    _logger.i('Destination marker added. Total markers: ${markers.length}');

    // Get and draw route from pickup to destination - AWAIT this!
    await _getRoutePickupToDestination();
    _logger.i('Route fetched. Route points count: ${_currentRoutePoints.length}');

    // Start location tracking for destination route AFTER route is fetched
    _startLocationTracking();

    // Move camera to show both locations
    _fitPickupAndDestination();

    _logger.i('Calling update() after showRouteToDestination setup');
    update();
  }

  // Show route from current location to pickup with polyline
  Future<void> showRouteToPickup({
    required double pickupLat,
    required double pickupLng,
    required String pickupName,
  }) async {
    _logger.i('showRouteToPickup called - pickupLat: $pickupLat, pickupLng: $pickupLng, pickupName: $pickupName');
    _logger.i('Current position: $currentPosition');

    this.pickupLocation = LatLng(pickupLat, pickupLng);
    this.pickupName = pickupName;
    isNavigatingToPickup.value = true;

    // Reset route tracking for new route
    _currentRoutePoints = [];
    _currentRouteSegmentIndex = 0;

    // Add pickup marker with custom icon
    markers.add(
      Marker(
        markerId: const MarkerId('pickup_location'),
        position: LatLng(pickupLat, pickupLng),
        icon: _pickupMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Pickup', snippet: pickupName),
      ),
    );
    _logger.i('Pickup marker added. Total markers: ${markers.length}');

    // Get and draw route from current location to pickup - AWAIT this!
    await _getRouteToPickup();
    _logger.i('Route fetched. Route points count: ${_currentRoutePoints.length}');

    // Start real-time location tracking AFTER route is fetched
    _startLocationTracking();

    // Move camera to show both locations
    _fitBothLocations();

    _logger.i('Calling update() after showRouteToPickup setup');
    update();
  }

  Future<void> _getRoutePickupToDestination() async {
    if (pickupLocation == null || destinationLocation == null) {
      _logger.e('Cannot get route - missing pickup or destination location');
      return;
    }

    try {
      final origin = '${pickupLocation!.latitude},${pickupLocation!.longitude}';
      final destination = '${destinationLocation!.latitude},${destinationLocation!.longitude}';

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$origin&destination=$destination&key=$_googleApiKey&mode=driving',
      );

      _logger.i('Fetching route from pickup to destination via Google Directions API');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polylinePoints = _decodePolyline(points);

          // Store route points for snap-to-route and bearing calculation
          _currentRoutePoints = polylinePoints;
          _currentRouteSegmentIndex = 0;

          polylines.value = {
            Polyline(
              polylineId: const PolylineId('route_pickup_to_destination'),
              points: polylinePoints,
              color: Colors.black,
              width: 5,
            ),
          };

          _logger.i('Route polyline drawn with ${polylinePoints.length} points');
          update();
        } else {
          _logger.e('No routes found: ${data['status']}');
          // Fallback: draw straight line
          _drawStraightLinePickupToDestination();
        }
      } else {
        _logger.e('Directions API error: ${response.statusCode}');
        _drawStraightLinePickupToDestination();
      }
    } catch (e) {
      _logger.e('Error fetching route: $e');
      _drawStraightLinePickupToDestination();
    }
  }

  Future<void> _getRouteToPickup() async {
    _logger.i('_getRouteToPickup called - currentPosition: $currentPosition, pickupLocation: $pickupLocation');

    if (currentPosition == null || pickupLocation == null) {
      _logger.e('Cannot get route - missing current position or pickup location');
      return;
    }

    try {
      final origin = '${currentPosition!.latitude},${currentPosition!.longitude}';
      final destination = '${pickupLocation!.latitude},${pickupLocation!.longitude}';

      _logger.i('Route request - origin: $origin, destination: $destination');

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$origin&destination=$destination&key=$_googleApiKey&mode=driving',
      );

      _logger.i('Fetching route from Google Directions API: $url');
      final response = await http.get(url);

      _logger.i('Directions API response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _logger.i('Directions API response status: ${data['status']}');

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polylinePoints = _decodePolyline(points);

          _logger.i('Decoded ${polylinePoints.length} polyline points');

          // Store route points for snap-to-route and bearing calculation
          _currentRoutePoints = polylinePoints;
          _currentRouteSegmentIndex = 0;

          polylines.value = {
            Polyline(
              polylineId: const PolylineId('route_to_pickup'),
              points: polylinePoints,
              color: Colors.black,
              width: 5,
            ),
          };

          _logger.i('Polylines set. Current polylines count: ${polylines.value.length}');
          _logger.i('Calling update() after setting polylines');
          update();
        } else {
          _logger.e('No routes found: ${data['status']}');
          _logger.i('API response: ${response.body}');
          // Fallback: draw straight line
          _drawStraightLine();
        }
      } else {
        _logger.e('Directions API error: ${response.statusCode}');
        _logger.i('API response body: ${response.body}');
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
    _logger.i('_drawStraightLine called - currentPosition: $currentPosition, pickupLocation: $pickupLocation');

    if (currentPosition == null || pickupLocation == null) {
      _logger.e('Cannot draw straight line - missing position data');
      return;
    }

    polylines.value = {
      Polyline(
        polylineId: const PolylineId('route_to_pickup'),
        points: [
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
          pickupLocation!,
        ],
        color: Colors.black,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    _logger.i('Drew straight line fallback. Polylines count: ${polylines.value.length}');
    update();
  }

  // Fallback: draw straight line from pickup to destination if API fails
  void _drawStraightLinePickupToDestination() {
    if (pickupLocation == null || destinationLocation == null) return;

    polylines.value = {
      Polyline(
        polylineId: const PolylineId('route_pickup_to_destination'),
        points: [
          pickupLocation!,
          destinationLocation!,
        ],
        color: Colors.black,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    _logger.i('Drew straight line fallback from pickup to destination');
    update();
  }

  // Fit camera to show both pickup and destination
  void _fitPickupAndDestination() {
    if (mapController == null || pickupLocation == null || destinationLocation == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        pickupLocation!.latitude < destinationLocation!.latitude
            ? pickupLocation!.latitude
            : destinationLocation!.latitude,
        pickupLocation!.longitude < destinationLocation!.longitude
            ? pickupLocation!.longitude
            : destinationLocation!.longitude,
      ),
      northeast: LatLng(
        pickupLocation!.latitude > destinationLocation!.latitude
            ? pickupLocation!.latitude
            : destinationLocation!.latitude,
        pickupLocation!.longitude > destinationLocation!.longitude
            ? pickupLocation!.longitude
            : destinationLocation!.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _startLocationTracking() {
    _logger.i('Starting real-time location tracking');
    _logger.i('Route points available: ${_currentRoutePoints.length}');

    _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) async {
      _logger.i('Location updated: ${position.latitude}, ${position.longitude}');
      _logger.i('Current route points count: ${_currentRoutePoints.length}');

      currentPosition = position;

      final currentLatLng = LatLng(position.latitude, position.longitude);

      // Snap to route and get bearing if we have route points
      if (_currentRoutePoints.isNotEmpty) {
        final snappedResult = _snapToRouteWithBearing(currentLatLng);

        // Update current bearing and segment index
        _currentBearing = snappedResult.bearing;
        _currentRouteSegmentIndex = snappedResult.segmentIndex;

        _logger.i('ROTATION DEBUG - Bearing: ${snappedResult.bearing.toStringAsFixed(1)}°, Segment: ${snappedResult.segmentIndex}');

        // Update driver marker with snapped position and rotated bitmap
        await _updateDriverMarkerWithRotation(snappedResult.position, snappedResult.bearing);

        _logger.i('Driver marker updated - snapped position: ${snappedResult.position}, bearing: ${snappedResult.bearing.toStringAsFixed(1)}°');
      } else {
        _logger.w('No route points available - marker will not rotate');
        // No route, just update marker at actual position without rotation
        markers.removeWhere((m) => m.markerId.value == 'driver_location');
        markers.add(
          Marker(
            markerId: const MarkerId('driver_location'),
            position: currentLatLng,
            icon: _driverMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'You'),
          ),
        );
      }

      // NOTE: Removed route re-fetch to avoid resetting route points and segment index

      update();
    });
  }

  // ==================== SIMULATION MODE ====================

  /// Start simulation mode - car auto-moves along the route
  void startSimulation() {
    if (_currentRoutePoints.isEmpty) {
      _logger.e('Cannot start simulation - no route points available');
      return;
    }

    _logger.i('Starting route simulation with ${_currentRoutePoints.length} points');

    // Stop real GPS tracking if active
    _locationSubscription?.cancel();
    _locationSubscription = null;

    // Reset simulation state
    _simulationPointIndex = 0;
    _simulationProgress = 0.0;
    isSimulationMode.value = true;

    // Start simulation timer
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(
      const Duration(milliseconds: _simulationIntervalMs),
      (_) => _advanceSimulation(),
    );

    update();
  }

  /// Stop simulation mode
  void stopSimulation() {
    _logger.i('Stopping route simulation');

    _simulationTimer?.cancel();
    _simulationTimer = null;
    isSimulationMode.value = false;
    _simulationPointIndex = 0;
    _simulationProgress = 0.0;

    update();
  }

  /// Toggle simulation mode on/off
  void toggleSimulation() {
    if (isSimulationMode.value) {
      stopSimulation();
    } else {
      startSimulation();
    }
  }

  /// Advance the simulation by one step
  Future<void> _advanceSimulation() async {
    if (_currentRoutePoints.isEmpty || _simulationPointIndex >= _currentRoutePoints.length - 1) {
      _logger.i('Simulation reached end of route');
      stopSimulation();
      return;
    }

    // Get current and next points
    final currentPoint = _currentRoutePoints[_simulationPointIndex];
    final nextPoint = _currentRoutePoints[_simulationPointIndex + 1];

    // Advance progress
    _simulationProgress += _simulationSpeed;

    // Check if we've reached the next point
    if (_simulationProgress >= 1.0) {
      _simulationProgress = 0.0;
      _simulationPointIndex++;

      if (_simulationPointIndex >= _currentRoutePoints.length - 1) {
        _logger.i('Simulation completed - reached destination');
        stopSimulation();
        return;
      }
    }

    // Interpolate position between current and next point
    final interpolatedPosition = _interpolatePosition(
      currentPoint,
      nextPoint,
      _simulationProgress,
    );

    // Calculate bearing to next point
    final bearing = _calculateBearing(currentPoint, nextPoint);

    // Update marker with interpolated position and rotation
    await _updateDriverMarkerWithRotation(interpolatedPosition, bearing);

    _logger.d('Simulation: point $_simulationPointIndex/${_currentRoutePoints.length - 1}, progress: ${(_simulationProgress * 100).toStringAsFixed(0)}%, bearing: ${bearing.toStringAsFixed(1)}°');

    update();
  }

  /// Interpolate between two LatLng points
  LatLng _interpolatePosition(LatLng from, LatLng to, double progress) {
    final lat = from.latitude + (to.latitude - from.latitude) * progress;
    final lng = from.longitude + (to.longitude - from.longitude) * progress;
    return LatLng(lat, lng);
  }

  /// Set simulation speed (0.01 = slow, 0.1 = fast)
  void setSimulationSpeed(double speed) {
    _logger.i('Setting simulation speed to $speed');
    // Note: This requires restarting simulation to take effect
    // For dynamic speed, you'd modify _simulationSpeed directly
  }

  // ==================== END SIMULATION MODE ====================

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

    // Stop simulation if running
    stopSimulation();

    // Clear route tracking data
    _currentRoutePoints = [];
    _currentRouteSegmentIndex = 0;
    _currentBearing = 0.0;

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

      // Get rotated car bitmap (initial bearing is 0)
      final rotatedIcon = await _getRotatedCarBitmap(_currentBearing);

      markers = {
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: rotatedIcon,
          infoWindow: const InfoWindow(title: 'You'),
          anchor: const Offset(0.5, 0.5),
          flat: true,
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
    _simulationTimer?.cancel();
    // Remove socket listeners
    SocketIoService.to.offRideRequest();
    SocketIoService.to.offRideAccepted();
    super.onClose();
  }
}
