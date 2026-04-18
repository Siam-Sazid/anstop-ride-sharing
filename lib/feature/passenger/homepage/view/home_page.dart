import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/passenger/car_booking/passenger/set_on_map_screen.dart';
import 'package:ride_sharing/feature/passenger/homepage/controller/home_page_controller.dart';
import 'package:ride_sharing/feature/passenger/set_location/view/set_location_option_page.dart';

import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/feature/passenger/passenger_common_utils/custom_google_map.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/driver/profile/controller/driver_profile_controller.dart';
import 'package:ride_sharing/l10n/app_localizations.dart';
import '../../../../utils/passenger/passenger_custom_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DriverProfileController _profileController = Get.put(DriverProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarTitle(scaffoldKey: _scaffoldKey,),
      drawer: PassengerCustomDrawer(),
      body: GetBuilder<HomePageController>(
        builder: (controller) {
          return Stack(
            children: [

              PassengerGoogleMapWidget(),
              if (controller.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),

              // Current location info card
              if (controller.currentPosition != null && !controller.isLoading)
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      color: AppColors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              onTap: (){
                               Get.to(SetOnMapScreen());
                              },
                              controller: controller.locationTEController,
                              prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
                              suffixIcon: Icon(CupertinoIcons.search_circle),
                              hintText: AppLocalization.tr.whereAreYouHeadedHint,
                              borderColor: AppColors.primaryColor,
                              borderRadio: 20,
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.sp),
                              child: Container(
                                height: 69.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: AppColors.greenShade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomLocationButton(
                                        imageUrl: AppImage.home,
                                        mainText: AppLocalization.tr.homeOption,
                                        subText: AppLocalization.tr.setAddressSubtitle,
                                        onTap: () {
                                          print('Location button tapped');
                                          Get.to(SetLocationOptionPage());
                                        },
                                      ),
                                      VerticalDivider(color: AppColors.white, width: 5),
                                      CustomLocationButton(
                                        imageUrl: AppImage.briefcase,
                                        mainText: AppLocalization.tr.workOption,
                                        subText: AppLocalization.tr.setAddressSubtitle,
                                        onTap: () {
                                          print('Location button tapped');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Account inactive overlay — non-modal, AppBar/drawer stay active
              Obx(() {
                if (!_profileController.isAccountInactive.value) return const SizedBox.shrink();
                final l10n = AppLocalizations.of(context)!;
                return Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_clock, size: 48.sp, color: AppColors.primaryColor),
                              SizedBox(height: 16.h),
                              Text(
                                l10n.accountInactiveTitle,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                l10n.accountInactiveMessage,
                                style: TextStyle(fontSize: 14.sp),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}