import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/splash_screen/passenger_auth_selection_screen.dart';
import 'package:ride_sharing/feature/splash_screen/role_selection_screen.dart';

import '../../widgets/custom_sliding_container.dart';

class OnboardingPageThird extends StatelessWidget {
  const OnboardingPageThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Logo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
             SizedBox(
               height: 150.h,
             ),
              Center(
                  child: Image.asset(
                    'assets/images/pana.png',
                    height: 212.h,
                    width: 345.w,
                    fit: BoxFit.contain,
                  ),
                ),

               SizedBox(height: 30.h),
              const Text(
                'Easy and Convenient',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Center(
                child: Text(
                  'Booking',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green400,
                  ),
                ),
              ),
               SizedBox(height: 30.h),
              const Text(
                'Book your ride in just a few taps. Quick, easy, and hassle-free.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

               SizedBox(height: 20.h,),
              OnboardingIndicator(
                totalPages: 3,
                currentPage: 2,
                activeWidth: 21,
                inactiveWidth: 13,
                height: 5,
                borderRadius: 100,
                activeColor: AppColors.violetFoundation,
                inactiveColor: AppColors.greyShade,
                spacing: 5,           // Space between indicators
              ),
               SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Get.to(RoleSelectionScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Get started !!'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}