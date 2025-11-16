import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/driver/registration.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/auth/passenger/registration.dart';

import '../auth/email_validation_screen.dart';
import '../auth/otp_varification_screen.dart';
import '../auth/reset_password_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToNextRoute();
  }

  Future<void> _goToNextRoute() async {
    await Future.delayed(Duration(seconds: 2));
     Get.offAll(() => LogInScreen());
   // Get.offAll(() => DriverRegistration());
   // Get.offAll(() => EmailValidationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Splash Screen')));
  }
}
