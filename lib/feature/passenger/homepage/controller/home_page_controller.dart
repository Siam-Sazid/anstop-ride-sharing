import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_sharing/l10n/app_localizations.dart';
import 'package:ride_sharing/services/socket_services.dart';

class HomePageController extends GetxController {
  final TextEditingController locationTEController = TextEditingController();
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  // Non-modal bottom sheet support — allows map to remain touchable
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _currentSheetController;

  void showPassengerSheet(WidgetBuilder builder) {
    _currentSheetController?.close();
    _currentSheetController = scaffoldKey.currentState?.showBottomSheet(
      builder,
      backgroundColor: Colors.transparent,
      enableDrag: false,
    );
  }

  void closeCurrentSheet() {
    _currentSheetController?.close();
    _currentSheetController = null;
  }

  static const String _googleApiKey = 'AIzaSyD_NVUY504HfMBsvN1gACNyfaFKAulvkVI';
  static const int _carImageSize = 80;

  // Custom marker icons
  ui.Image? _carImage;
  BitmapDescriptor? _pinMarkerIcon;

  // Route state for snap-to-route bearing
  List<LatLng> _currentRoutePoints = [];
  int _currentRouteSegmentIndex = 0;
  double _currentBearing = 0.0;

  // Tracks last position where Directions API was called — avoids redundant fetches
  LatLng? _lastFetchedDriverLocation;

  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 14.0,
  );

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _loadIcons();
    await _requestLocationPermission();
    await _getCurrentLocation();
  }

  // ─── Icon loading ──────────────────────────────────────────────────────────

  Future<void> _loadIcons() async {
    try {
      _pinMarkerIcon = await _getBitmapDescriptorFromAsset(
        'assets/images/location_pin.png',
        50,
      );
      _carImage = await _loadCarImage('assets/images/3D_car.png', _carImageSize);
    } catch (_) {
      // Fallback to defaults if assets are missing
    }
  }

  Future<ui.Image> _loadCarImage(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(
      String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  /// Rotates the car image by [degrees] and returns it as a BitmapDescriptor.
  Future<BitmapDescriptor> _getRotatedCarBitmap(double degrees) async {
    if (_carImage == null) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }

    final int w = _carImage!.width;
    final int h = _carImage!.height;
    final double diagonal = sqrt(w * w + h * h);
    final int canvasSize = diagonal.ceil();

    final double radians = degrees * pi / 180;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, canvasSize.toDouble(), canvasSize.toDouble()));

    final double cx = canvasSize / 2.0;
    final double cy = canvasSize / 2.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(radians);
    canvas.drawImage(
      _carImage!,
      Offset(-w / 2.0, -h / 2.0),
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();

    final ui.Picture picture = recorder.endRecording();
    final ui.Image rotatedImage = await picture.toImage(canvasSize, canvasSize);
    final ByteData? byteData =
        await rotatedImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }

  // ─── Bearing & snap-to-route ───────────────────────────────────────────────

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final diffLng = (to.longitude - from.longitude) * pi / 180;

    final x = sin(diffLng) * cos(lat2);
    final y = cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(diffLng);

    return (atan2(x, y) * 180 / pi + 360) % 360;
  }

  /// Snaps [pos] to the nearest point on the stored route and returns its
  /// bearing toward the next route point.
  ({LatLng position, double bearing}) _snapToRoute(LatLng pos) {
    if (_currentRoutePoints.isEmpty) {
      return (position: pos, bearing: _currentBearing);
    }

    double minDist = double.infinity;
    LatLng closestPoint = pos;
    int closestIdx = _currentRouteSegmentIndex;

    final start = max(0, _currentRouteSegmentIndex - 2);
    for (int i = start; i < _currentRoutePoints.length; i++) {
      final d = _haversineKm(
            pos.latitude,
            pos.longitude,
            _currentRoutePoints[i].latitude,
            _currentRoutePoints[i].longitude,
          ) *
          1000; // metres
      if (d < minDist) {
        minDist = d;
        closestPoint = _currentRoutePoints[i];
        closestIdx = i;
      }
    }

    _currentRouteSegmentIndex = closestIdx;

    double bearing = _currentBearing;
    if (closestIdx < _currentRoutePoints.length - 1) {
      bearing = _calculateBearing(
          closestPoint, _currentRoutePoints[closestIdx + 1]);
    }
    _currentBearing = bearing;

    return (position: closestPoint, bearing: bearing);
  }

  /// Updates the driver marker with a rotated car icon at [position].
  Future<void> _updateDriverMarkerWithRotation(
      LatLng position, double bearing, String locationName) async {
    final BitmapDescriptor icon = await _getRotatedCarBitmap(bearing);

    markers = {
      ...markers.where((m) => m.markerId.value != 'driver_location'),
      Marker(
        markerId: const MarkerId('driver_location'),
        position: position,
        icon: icon,
        infoWindow: InfoWindow(title: locationName),
        anchor: const Offset(0.5, 0.5),
        flat: true,
      ),
    };
  }

  // ─── Location permission & initial position ────────────────────────────────

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

      final l10n = AppLocalizations.of(Get.context!)!;
      markers = {
        ...markers,
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: l10n.yourLocationMarker),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
      update();

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

  // ─── Driver location tracking + polyline ──────────────────────────────────

  void startDriverLocationTracking(LatLng pickupLocation) {
    _lastFetchedDriverLocation = null;
    _resetRouteState();

    debugPrint('🟢 [POLYLINE DEBUG] startDriverLocationTracking called');
    debugPrint('🟢 [POLYLINE DEBUG] pickupLocation = ${pickupLocation.latitude}, ${pickupLocation.longitude}');

    // Add pickup pin marker
    _addPinMarker('pickup_location', pickupLocation, 'Pickup');

    SocketIoService.to.onUpdateLocation((data) async {
      if (data == null || data is! Map<String, dynamic>) return;

      final lat = (data['latitude'] as num).toDouble();
      final lng = (data['longitude'] as num).toDouble();
      final locationName = data['locationName'] as String? ?? 'Driver';
      final driverLatLng = LatLng(lat, lng);

      debugPrint('🟡 [POLYLINE DEBUG] update-location received → driver lat=$lat, lng=$lng');
      debugPrint('🟡 [POLYLINE DEBUG] polyline origin (driver) = $lat, $lng');
      debugPrint('🟡 [POLYLINE DEBUG] polyline destination (pickup) = ${pickupLocation.latitude}, ${pickupLocation.longitude}');

      // Only re-fetch Directions API when driver has moved ≥ 50 m
      final shouldFetch = _lastFetchedDriverLocation == null ||
          _haversineKm(
                _lastFetchedDriverLocation!.latitude,
                _lastFetchedDriverLocation!.longitude,
                lat,
                lng,
              ) >=
              0.05;

      debugPrint('🟡 [POLYLINE DEBUG] shouldFetch=$shouldFetch (lastFetched=${_lastFetchedDriverLocation?.latitude}, ${_lastFetchedDriverLocation?.longitude})');

      if (shouldFetch) {
        _lastFetchedDriverLocation = driverLatLng;
        await _fetchAndDrawRoute(driverLatLng, pickupLocation);
      }

      // Snap to route for smooth bearing
      final snapped = _snapToRoute(driverLatLng);
      await _updateDriverMarkerWithRotation(
          snapped.position, snapped.bearing, locationName);
      update();

      // Animate camera to keep both driver and pickup in frame
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(lat, pickupLocation.latitude) - 0.005,
          min(lng, pickupLocation.longitude) - 0.005,
        ),
        northeast: LatLng(
          max(lat, pickupLocation.latitude) + 0.005,
          max(lng, pickupLocation.longitude) + 0.005,
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    });
  }

  // Switch polyline target from pickup → destination when ride begins
  void startRideToDestinationTracking(LatLng destination) {
    SocketIoService.to.offUpdateLocation();
    _lastFetchedDriverLocation = null;
    _resetRouteState();

    // Replace pickup pin with destination pin
    markers = Set<Marker>.from(
        markers.where((m) => m.markerId.value != 'pickup_location'));
    _addPinMarker('destination_location', destination, 'Destination');

    SocketIoService.to.onUpdateLocation((data) async {
      if (data == null || data is! Map<String, dynamic>) return;

      final lat = (data['latitude'] as num).toDouble();
      final lng = (data['longitude'] as num).toDouble();
      final locationName = data['locationName'] as String? ?? 'Driver';
      final driverLatLng = LatLng(lat, lng);

      // Re-fetch route only when driver moves ≥ 50 m
      final shouldFetch = _lastFetchedDriverLocation == null ||
          _haversineKm(
                _lastFetchedDriverLocation!.latitude,
                _lastFetchedDriverLocation!.longitude,
                lat,
                lng,
              ) >=
              0.05;

      if (shouldFetch) {
        _lastFetchedDriverLocation = driverLatLng;
        await _fetchAndDrawRoute(driverLatLng, destination);
      }

      // Snap to route for smooth bearing
      final snapped = _snapToRoute(driverLatLng);
      await _updateDriverMarkerWithRotation(
          snapped.position, snapped.bearing, locationName);
      update();

      // Keep both driver and destination in frame
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(lat, destination.latitude) - 0.005,
          min(lng, destination.longitude) - 0.005,
        ),
        northeast: LatLng(
          max(lat, destination.latitude) + 0.005,
          max(lng, destination.longitude) + 0.005,
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    });
  }

  void stopDriverLocationTracking() {
    SocketIoService.to.offUpdateLocation();
    _lastFetchedDriverLocation = null;
    _resetRouteState();
    polylines = {};
    markers = Set<Marker>.from(
      markers.where((m) =>
          m.markerId.value != 'driver_location' &&
          m.markerId.value != 'pickup_location' &&
          m.markerId.value != 'destination_location'),
    );
    update();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _resetRouteState() {
    _currentRoutePoints = [];
    _currentRouteSegmentIndex = 0;
    _currentBearing = 0.0;
  }

  void _addPinMarker(String id, LatLng position, String title) {
    markers = {
      ...markers.where((m) => m.markerId.value != id),
      Marker(
        markerId: MarkerId(id),
        position: position,
        icon: _pinMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: title),
      ),
    };
  }

  Future<void> _fetchAndDrawRoute(LatLng origin, LatLng destination) async {
    debugPrint('🔶 [POLYLINE DEBUG] _fetchAndDrawRoute called');
    debugPrint('🔶 [POLYLINE DEBUG] origin (should be DRIVER) = ${origin.latitude}, ${origin.longitude}');
    debugPrint('🔶 [POLYLINE DEBUG] destination (should be PICKUP/DEST) = ${destination.latitude}, ${destination.longitude}');
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$_googleApiKey&mode=driving',
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('🔶 [POLYLINE DEBUG] Directions API status = ${data['status']}');

      if (data['status'] == 'OK') {
        final encoded =
            data['routes'][0]['overview_polyline']['points'] as String;
        final routePoints = _decodePolyline(encoded);

        // Store for snap-to-route bearing calculations
        _currentRoutePoints = routePoints;
        _currentRouteSegmentIndex = 0;

        polylines = {
          Polyline(
            polylineId: const PolylineId('driver_to_pickup'),
            points: routePoints,
            color: Colors.black,
            width: 5,
          ),
        };
      } else {
        _fallbackStraightLine(origin, destination);
      }
    } catch (_) {
      _fallbackStraightLine(origin, destination);
    }

    update();
  }

  void _fallbackStraightLine(LatLng origin, LatLng destination) {
    _currentRoutePoints = [origin, destination];
    polylines = {
      Polyline(
        polylineId: const PolylineId('driver_to_pickup'),
        points: [origin, destination],
        color: Colors.black,
        width: 5,
      ),
    };
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
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
      final int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  // ──────────────────────────────────────────────────────────────────────────

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
