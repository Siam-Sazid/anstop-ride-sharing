import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:ride_sharing/app.dart';
import 'package:ride_sharing/services/socket_services.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Maps to use Hybrid Composition on Android
  _initializeMapRenderer();

  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Initialize Stripe with publishable key
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Firebase.initializeApp();
  await Get.putAsync<SocketIoService>(() async {
    final service = SocketIoService();
    await service.init();
    return service;
  });

  runApp(const RideSharingApp());
}

void _initializeMapRenderer() {
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
}