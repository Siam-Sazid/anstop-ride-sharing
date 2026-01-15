import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/feature/auth/view/log_in_screen.dart';
import 'package:ride_sharing/feature/driver/homepage/view/driver_homescreen.dart';
import 'package:ride_sharing/feature/passenger/my_ride/view/my_ride.dart';
import 'package:ride_sharing/feature/passenger/wallet/view/passenger_wallet_page.dart';
import 'package:ride_sharing/feature/settings/view/settings_screen.dart';
import 'package:ride_sharing/routes/app_routes.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/feature/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/view/log_out_dialog.dart';
import '../custom_user_rating.dart';

class PassengerCustomDrawer extends StatelessWidget {
  const PassengerCustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerShade,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // Drawer Header
          Padding(
            padding: EdgeInsets.only(left:  32.sp, top: 50.sp,right: 32.sp),
            child: Container(
              height: 74.h,
             // color: AppColors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),

              ),
              child: CustomUserRating(
                name: AppLocalization.tr.exampleUserName,
                imageUrl: "https://picsum.photos/250?image=9",
              //  price: 24,
             //   distance: 28,
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only( bottom: 220.sp,top: 32.sp,right: 32.sp,left: 32.sp),
              child: Container(
                height: 256.h,
                width: 236,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),

                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _drawerItem(
                      imagePath: AppImage.notification,
                      text: AppLocalization.tr.notificationMenuItem,
                      onTap: () {},
                    ),

                    _drawerItem(
                      imagePath: AppImage.carDrawer,
                      text: AppLocalization.tr.myRideMenuItem,
                      onTap: () {
                      //  Get.to(MyRidePage());
                        Get.toNamed(AppRoutes.passengerMyRideScreen);
                        },
                    ),

                    _drawerItem(
                      imagePath: AppImage.walletDrawer,
                      text: AppLocalization.tr.walletMenuItem,
                      onTap: () {
                       // Get.to(PassengerWalletPage());
                        Get.toNamed(AppRoutes.passengerWalletScreen);

                      },
                    ),
                    _drawerItem(
                      imagePath: AppImage.support,
                      text: AppLocalization.tr.supportMenuItem,
                      onTap: () {
                        Get.toNamed(AppRoutes.supportListScreen);
                      },
                    ),
                    _drawerItem(
                      imagePath: AppImage.settings,
                      text: AppLocalization.tr.settingsMenuItem,
                      onTap: () {
                        Get.to(SettingsScreen());

                      },
                     ),
                    _drawerItem(
                      imagePath: AppImage.logout,
                      text: AppLocalization.tr.logoutMenuItem,
                      onTap: () async {
                        // Show the logout dialog
                        final result = await LogoutDialog.show(context);

                        // If user confirmed logout
                        if (result == true) {

                         //  Get.to(() => LogInScreen());
                          Get.toNamed(AppRoutes.loginScreen);

                        }
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),

          // Switch to Driver button
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: CustomButton(
                onPressed: () => _handleSwitchToDriver(context),
             title: Text(AppLocalization.tr.switchToDriverButton,style: TextStyle(color: AppColors.white),),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleSwitchToDriver(BuildContext context) async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // Debug logging
      print('🔑 Access Token: $accessToken');
      print('🔑 All SharedPreferences keys: ${prefs.getKeys()}');
      print('🔑 User Role: ${prefs.getStringList('userRole')}');

      if (accessToken == null || accessToken.isEmpty) {
        Get.back(); // Close loading

        // Show dialog asking user to re-login
        await Get.dialog(
          AlertDialog(
            title: Text('Login Required'),
            content: Text('Please log out and log in again to switch to driver mode.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.toNamed(AppRoutes.loginScreen); // Navigate to login
                },
                child: Text('Go to Login'),
              ),
              TextButton(
                onPressed: () => Get.back(), // Close dialog
                child: Text('Cancel'),
              ),
            ],
          ),
        );
        return;
      }

      // Check onboarding status
      final authService = AuthService();
      final onboardingResponse = await authService.getDriverOnboardingStatus(
        accessToken: accessToken,
      );

      Get.back(); // Close loading

      if (onboardingResponse.isSuccess) {
        final isOnboarded = onboardingResponse.responseData['data']?['isOnboarded'] ?? false;

        if (isOnboarded) {
          // Driver is fully onboarded, go to driver home screen
          Get.toNamed(AppRoutes.driverHomeScreen);
        } else {
          // Driver needs to complete onboarding
          Get.toNamed(AppRoutes.driverRegistrationScreen);
        }
      } else {
        // If onboarding status check fails, go to registration
        Get.toNamed(AppRoutes.driverRegistrationScreen);
      }
    } catch (e) {
      Get.back(); // Close loading if open
      print('Error switching to driver: $e');
      Get.snackbar(
        'Error',
        'Failed to switch to driver mode. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _drawerItem({
    required String imagePath,   // 🔥 changed
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 24.w,       // adjust size as needed
        height: 24.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 15.sp),
      ),
      onTap: onTap,
    );
  }

}
