import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/car_booking/passenger/set_on_map_screen.dart';
import 'package:ride_sharing/feature/homepage/passenger/controller/home_page_controller.dart';
import 'package:ride_sharing/feature/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/widgets/custom_google_map.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarTitle(scaffoldKey: _scaffoldKey,),
      drawer: CustomDrawer(),
      body: GetBuilder<HomePageController>(
        builder: (controller) {
          return Stack(
            children: [

              GoogleMapWidget(),
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
                              hintText: 'Where are you headed?',
                              borderColor: AppColors.primaryColor,
                              borderRadio: 20,
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.sp),
                              child: Container(
                                height: 70.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: AppColors.greenShade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomLocationButton(
                                        imageUrl: 'assets/images/home.png',
                                        mainText: 'Home',
                                        subText: 'Set address',
                                        onTap: () {
                                          print('Location button tapped');
                                          Get.to(SetLocationOptionPage());
                                        },
                                      ),
                                      VerticalDivider(color: AppColors.white, width: 5),
                                      CustomLocationButton(
                                        imageUrl: 'assets/images/briefcase.png',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}