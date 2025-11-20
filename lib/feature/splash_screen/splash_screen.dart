import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/driver/registration.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/auth/passenger/registration.dart';
import 'package:ride_sharing/feature/driver/homepage/view/driver_homescreen.dart';
import 'package:ride_sharing/feature/splash_screen/onboarding_page_first.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

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
   //  Get.offAll(() => LogInScreen());
   // Get.offAll(() => DriverRegistration());
   // Get.offAll(() => EmailValidationScreen());
   // Get.offAll(() => DriverHomeScreen());
    Get.offAll(() => OnboardingPageFirst());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5D6C7),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen.png', // Replace with your actual image
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('English'),
                      Switch(
                        value: false, // You can manage state for language toggle
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        activeTrackColor: Colors.grey[300],
                      ),
                      const Text('French'),
                    ],
                  ),
                  const Spacer(),
                  LogoWidget(),
                  const SizedBox(height: 20),
                  const Text(
                    'Seamless, affordable, and reliable ride-sharing at your fingertips.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
