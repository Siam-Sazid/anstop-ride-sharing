import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/feature/passenger/my_ride/view/my_ride.dart';
import 'package:ride_sharing/feature/passenger/wallet/view/passenger_wallet_page.dart';
import 'package:ride_sharing/feature/settings/view/settings_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

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
              padding:  EdgeInsets.only( bottom: 250.sp,top: 32.sp,right: 32.sp,left: 32.sp),
              child: Container(
                height: 100.h,
                width: 236,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),

                ),
                child: ListView(
                  children: [
                    _drawerItem(
                      imagePath: 'assets/images/notification.png',
                      text: "Notification",
                      onTap: () {},
                    ),

                    _drawerItem(
                      imagePath: 'assets/images/Car_drawer.png',
                      text: "My Ride",
                      onTap: () {
                        Get.to(MyRidePage());
                        },
                    ),

                    _drawerItem(
                      imagePath: 'assets/images/Wallet_drawer.png',
                      text: "Wallet",
                      onTap: () {
                        Get.to(PassengerWalletPage());
                      },
                    ), _drawerItem(
                      imagePath: 'assets/images/Support.png',
                      text: "Support",
                      onTap: () {},
                    ), _drawerItem(
                      imagePath: 'assets/images/settings.png',
                      text: "Settings",
                      onTap: () {
                        Get.to(SettingsScreen());

                      },
                     ),
                    _drawerItem(
                      imagePath: 'assets/images/logout.png',
                      text: "Logout",
                      onTap: () {},
                    ),

                  ],
                ),
              ),
            ),
          ),

          // Logout button
          Padding(
            padding: EdgeInsets.all(32.sp),
            child: CustomButton(
                onPressed: (){

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
