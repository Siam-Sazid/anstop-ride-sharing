import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/splash_screen/controller/splash_controller.dart';

import '../../l10n/l10n_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller (initialized via SplashBinding)
    final controller = Get.find<SplashController>();

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
                      Text(AppLocalization.tr.splashEnglishLabel),
                      Obx(() => Switch(
                            value: controller.isFrench.value,
                            onChanged: controller.toggleLanguage,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey[300],
                          )),
                      Text(AppLocalization.tr.splashFrenchLabel),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(AppImage.logoAnstop),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalization.tr.splashTagline,
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
