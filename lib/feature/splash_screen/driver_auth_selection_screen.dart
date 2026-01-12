import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/auth/driver/registration.dart';
import 'package:ride_sharing/feature/auth/view/log_in_screen.dart';
import 'package:ride_sharing/feature/auth/view/registration.dart';
class DriverAuthSelectionScreen extends StatelessWidget {
  const DriverAuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 150.h),
              Center(
                child: Image.asset(
                  AppImage.rafiki,
                  height: 300.h,
                  width: 348.w,
                  fit: BoxFit.contain,
                ),

              ),

              const SizedBox(height: 30),
              const Text(
                AppString.driverWelcomeTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
               Text(
                AppString.driverAuthTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {

                    Get.to(LogInScreen());

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(AppString.logInButton)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () {
                  Get.to(DriverRegistration());

                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor),
                  padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(AppString.registerButton) ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}