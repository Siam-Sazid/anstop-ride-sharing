import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/auth/driver/registration.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/auth/passenger/registration.dart';
import 'package:ride_sharing/feature/driver/homepage/view/driver_homescreen.dart';
import 'package:ride_sharing/feature/splash_screen/onboarding_page_first.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

import '../../l10n/l10n_helper.dart';
import '../auth/email_validation_screen.dart';
import '../auth/otp_varification_screen.dart';
import '../auth/reset_password_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFrench = false;

  @override
  void initState() {
    super.initState();
    _goToNextRoute();
  }

  void _toggleLanguage(bool value) {
    setState(() {
      isFrench = value;
    });
    // Update locale for GetX
    Get.updateLocale(isFrench ? const Locale('fr') : const Locale('en'));
  }

  Future<void> _goToNextRoute() async {
    await Future.delayed(Duration(seconds: 5));
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
              AppImage.splashScreen,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(L10n.tr.splashEnglishLabel),
                      Switch(
                        value: isFrench,
                        onChanged: _toggleLanguage,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.grey[300],
                      ),
                      Text(L10n.tr.splashFrenchLabel),
                    ],
                  ),
                  const Spacer(),
                  LogoWidget(),
                  const SizedBox(height: 20),
                  Text(
                    L10n.tr.splashTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
