import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/car_booking/passenger/controller/pick_up_location_controller.dart';
import 'package:ride_sharing/feature/car_booking/passenger/set_on_map_screen.dart';
import 'package:ride_sharing/feature/car_booking/utils/find_car_bottom_sheet.dart';
import 'package:ride_sharing/feature/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/widgets/custom_google_map.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing/widgets/custom_text_field.dart';  // Assuming you have this widget

class PickUpLocationScreen extends StatelessWidget {
  const PickUpLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarTitle(),
      body: GetBuilder<PickUpLocationController>(
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


              if (controller.currentPosition != null && !controller.isLoading)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 120.w,
                             height: 70.h,
                              decoration: BoxDecoration(
                                color:  AppColors.greenShade50,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/car.png',
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          Padding(
                            padding:  EdgeInsets.symmetric( horizontal:  8.sp),
                            child: Text('Your pick up point'),
                          ),
                          CustomTextField(
                            onTap: () {
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
                            padding:  EdgeInsets.symmetric( horizontal:  8.sp),
                            child: Text('Your destination'),
                          ),
                          CustomTextField(
                            onTap: () {
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
                            padding:  EdgeInsets.fromLTRB(16.sp,16.sp,16.sp,0.sp),
                            child: Row(
                              children: [
                                Text('Saved Adress', style:  TextStyle(fontSize: 20.sp),),
                                Spacer(),
                                Text('See all >', style:  TextStyle(fontSize: 15.sp,color: AppColors.greenShade50),)
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomLocationButton(
                                      imageUrl: 'https://picsum.photos/250?image=9',
                                      mainText: 'Home',
                                      subText: 'Set address',
                                      onTap: () {
                                        print('Location button tapped');
                                        Get.to(SetLocationOptionPage());
                                      },
                                    ),
                                    VerticalDivider(color: AppColors.white, width: 2),
                                    CustomLocationButton(
                                      imageUrl: 'https://picsum.photos/250?image=10',
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
                          SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white, // Adjust the color of the bottom bar
        child: Padding(
          padding: EdgeInsets.all(5),
          child: CustomButton(
            onPressed: () {

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FindCarBottomSheet(); // Call the custom bottom sheet widget here
                },
              );
            },
            title: Text(
              'Next',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
