import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/splash_screen/driver_auth_selection_screen.dart';
import 'package:ride_sharing/feature/splash_screen/passenger_auth_selection_screen.dart';
import '../../app/utils/app_colors.dart';
import 'package:get/get.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
           SizedBox(height: 200.h,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        AppImage.cuate,
                        height: 195.h,
                        width: 300.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'WELCOME To Our App',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Seamless, affordable, and reliable ride-sharing at your fingertips.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Container(
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Passenger Button
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const PassengerAuthSelectionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.passengerIcon,
                            height: 24.h,
                            width: 24.w,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'As a Passenger',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Driver Button
                    OutlinedButton(
                      onPressed: () {
                        Get.to(() => const DriverAuthSelectionScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.green300,
                        side: BorderSide(color: AppColors.green300, width: 2),
                        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.driverIcon,
                            height: 24.h,
                            width: 24.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Driver',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}