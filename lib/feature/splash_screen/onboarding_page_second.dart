import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/splash_screen/onboarding_page_third.dart';

import '../../widgets/custom_fade_slide.dart';
import '../../widgets/custom_sliding_container.dart';
import '../../widgets/logo.dart';


class OnboardingPageSecond extends StatelessWidget {
  const OnboardingPageSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomFadeSlide(
                delay: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LogoWidget(
                      height: 40.h,
                      width: 40.h,
                      fontSize: 14.sp,
                    ),
                    _skipButton(),
                  ],
                ),
              ),
               SizedBox(height: 150.h),

                 CustomFadeSlide(
                   delay: 150,
                   child: Center(
                    child: Image.asset(
                      AppImage.cuate,
                      height: 300.h,
                      width: 330.w,
                      fit: BoxFit.contain,
                    ),
                                   ),
                 ),

              //const SizedBox(height: 10),
               CustomFadeSlide(
                 delay: 300,
                 child: Text(
                  'Safe and Secure',
                  style: TextStyle(
                    fontSize: 26.sp ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                               ),
               ),
              CustomFadeSlide(
                delay: 450,
                child: Center(
                  child: Text(
                    'Journeys',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green400,
                    ),
                  ),
                ),
              ),
               SizedBox(height: 10.h ),
               CustomFadeSlide(
                 delay: 500,
                 child: Text(
                  'Your safety is our top priority. Every ride is monitored for your peace of mind.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp ,
                    color: Colors.black,
                  ),
                               ),
               ),
               SizedBox(height: 20.h),
              CustomFadeSlide(
                delay: 500,
                child: OnboardingIndicator(
                  totalPages: 3,
                  currentPage: 1,
                  activeWidth: 21,
                  inactiveWidth: 13,
                  height: 5,
                  borderRadius: 100,
                  activeColor: AppColors.violetFoundation,
                  inactiveColor: AppColors.greyShade,
                  spacing: 5,           // Space between indicators
                ),
              ),
              SizedBox(height: 20.h),
              CustomFadeSlide(
                delay: 600,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  OnboardingPageThird()),
                    );
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
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _skipButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Skip'),
    );
  }
}