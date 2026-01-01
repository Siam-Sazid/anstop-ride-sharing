import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/driver/homepage/view/driver_homescreen.dart';
import 'package:ride_sharing/feature/passenger/my_ride/view/my_ride.dart';
import 'package:ride_sharing/feature/passenger/wallet/view/passenger_wallet_page.dart';
import 'package:ride_sharing/feature/settings/view/settings_screen.dart';
import 'package:ride_sharing/feature/support_page/support_page.dart';
import 'package:ride_sharing/routes/app_routes.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

import '../../feature/auth/log_out_dialog.dart';
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
                name: "Naima Jahan",
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
                      text: "Notification",
                      onTap: () {},
                    ),

                    _drawerItem(
                      imagePath: AppImage.carDrawer,
                      text: "My Ride",
                      onTap: () {
                      //  Get.to(MyRidePage());
                        Get.toNamed(AppRoutes.passengerMyRideScreen);
                        },
                    ),

                    _drawerItem(
                      imagePath: AppImage.walletDrawer,
                      text: "Wallet",
                      onTap: () {
                       // Get.to(PassengerWalletPage());
                        Get.toNamed(AppRoutes.passengerWalletScreen);

                      },
                    ), _drawerItem(
                      imagePath: AppImage.support,
                      text: "Support",
                      onTap: () {
                        Get.to(SupportPage());

                      },
                    ), _drawerItem(
                      imagePath: AppImage.settings,
                      text: "Settings",
                      onTap: () {
                        Get.to(SettingsScreen());

                      },
                     ),
                    _drawerItem(
                      imagePath: AppImage.logout,
                      text: "Logout",
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

          // Logout button
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: CustomButton(
                onPressed: (){
               //   Get.to(DriverHomeScreen());
                  Get.toNamed(AppRoutes.driverHomeScreen);
                },
             title: Text('Switch to drive',style: TextStyle(color: AppColors.white),),
            ),
          )
        ],
      ),
    );
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
