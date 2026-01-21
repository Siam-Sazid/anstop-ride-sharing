import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app.dart';
import 'package:ride_sharing/services/socket_services.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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