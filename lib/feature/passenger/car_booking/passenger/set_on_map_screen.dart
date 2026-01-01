import 'package:flutter/cupertino.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/auth/email_validation_screen.dart';
import 'package:ride_sharing/feature/passenger/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_location_button.dart';

import '../../../../routes/app_routes.dart';
class SetOnMapScreen extends StatelessWidget {
  SetOnMapScreen({super.key});
  final TextEditingController locationTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,  // Aligning the image at the center
              children: [
                SizedBox(height: 66.h),
                CustomTextField(
                  controller: locationTEController,
                  prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
                  suffixIcon: Icon(CupertinoIcons.search_circle),
                  hintText: 'Where are you headed?',
                  borderColor: AppColors.primaryColor,
                  borderRadio: 20,
                ),
                SizedBox(height: 8),// Optional, adjust if needed
                SetLocationOptionCard(
                  icon: Icons.pin_drop_rounded,
                  title: 'Set on Map',
                  onTap: () {
                    Get.toNamed(AppRoutes.setLocationScreen);
                    print('Home tapped');
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.sp),
                  child: Container(
                    height: 70.h,
                    width: 345.w,
                    decoration: BoxDecoration(
                      color: AppColors.greenShade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomLocationButton(
                            imageUrl: AppImage.home,
                            mainText: 'Home',
                            subText: 'Set address',
                            onTap: () {
                              print('Location button tapped');
                              Get.to(SetLocationOptionPage());
                            },
                          ),
                          VerticalDivider(color: AppColors.white, width: 2),
                          CustomLocationButton(
                            imageUrl: AppImage.briefcase,
                            mainText: 'Work',
                            subText: 'Set address',
                            onTap: () {
                              print('Location button tapped');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ///If location is found
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){},
                      child: Text('Recent Places',style: TextStyle(
                        color: AppColors.grey400,fontSize: 16.sp
                      ),),
                    ),

                    GestureDetector(
                      onTap: (){},
                      child: Text('Clear all',style: TextStyle(
                          color: AppColors.green300),),
                    )
                  ],
                ),
                CustomListTile(
                  icon: Icon(CupertinoIcons.clock,color: AppColors.appGreyColor,),
                  title: 'Coffee',
                  subTitle: '35/3,Shantinagar Bazar Road',

                  trailing: Text(
                    '12.5 km',
                    style: TextStyle(
                      color: AppColors.appGreyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Define the action on tap here
                    Navigator.pop(context);
                    Get.toNamed(AppRoutes.pickUpLocationScreen);
                  },

                  borderRadius: 8,
                  titleColor: Colors.black,
                  titleFontSize: 16.sp,
                  subtitleFontSize: 12.sp,
                  contentPaddingHorizontal: 8.h,
                  contentPaddingVertical: 2.h,
                ),
                SizedBox(height: 8.h,),
                CustomListTile(
                  icon: Icon(CupertinoIcons.clock,color: AppColors.appGreyColor,),
                  title: 'Restaurant',
                  subTitle: '35/3,Banani Road',  // Subtitle of the ListTile

                  trailing: Text(
                    '15.35 km',  // Trailing text (distance in km)
                    style: TextStyle(
                      color: AppColors.appGreyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Define the action on tap here

                  },

                  borderRadius: 8,
                  titleColor: Colors.black,
                  titleFontSize: 16.sp,
                  subtitleFontSize: 12.sp,
                  contentPaddingHorizontal: 10.h,
                  contentPaddingVertical: 8.h,
                ),
                ///If no location is found
                // Center(
                //   child: Image.asset(
                //     'assets/images/no_data.png',
                //     width: 250.w,
                //     height: 250.h,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                // SizedBox(height: 5.h),
                // Center(child: Text('Not Found',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),)),
                //
                // SizedBox(height: 5.h),
                // Text('Sorry the keyword you entered cannot be found, please ',style: TextStyle(color: AppColors.appGreyColor),),
                // Center(child: Text('check again or search with another keyword',style: TextStyle(color: AppColors.appGreyColor),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

