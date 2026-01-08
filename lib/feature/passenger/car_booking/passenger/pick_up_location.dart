import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/feature/passenger/car_booking/passenger/controller/pick_up_location_controller.dart';
import 'package:ride_sharing/feature/passenger/car_booking/passenger/set_on_map_screen.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/find_car_bottom_sheet.dart';
import 'package:ride_sharing/feature/passenger/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/feature/passenger/passenger_common_utils/custom_google_map.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing/widgets/custom_text_field.dart';  // Assuming you have this widget
import 'package:geocoding/geocoding.dart';
class PickUpLocationScreen extends StatelessWidget {
   PickUpLocationScreen({Key? key}) : super(key: key);
  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
   Future<void> getCoordinates(String address) async {
     try {
       // Get the coordinates from the address
       List<Location> locations = await locationFromAddress(address);
       if (locations.isNotEmpty) {
         // Get the first location (if there are multiple results)
         double latitude = locations[0].latitude;
         double longitude = locations[0].longitude;

         // Update the controller to store the location
         print('Latitude: $latitude, Longitude: $longitude');

         // Do something with the coordinates (e.g., set on map)
       }
     } catch (e) {
       print('Error: $e');
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PickUpLocationController>(
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


              if (controller.currentPosition != null && !controller.isLoading)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                                  AppImage.car,
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          Padding(
                            padding:  EdgeInsets.symmetric( horizontal:  8.sp),
                            child: Text(L10n.tr.yourPickUpPointLabel),
                          ),
                          CustomTextField(
                            onTap: () {
                              Get.to(SetOnMapScreen());
                            },
                            controller: controller.locationTEController,
                            prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
                            suffixIcon: Icon(CupertinoIcons.search_circle),
                            hintText: L10n.tr.whereAreYouHeadedHint,
                            borderColor: AppColors.primaryColor,
                            borderRadio: 20,
                            onChanged: (address) {
                              getCoordinates(address);
                            },
                          ),

                          SizedBox(height: 8),
                          Padding(
                            padding:  EdgeInsets.symmetric( horizontal:  8.sp),
                            child: Text(L10n.tr.yourDestinationLabel),
                          ),
                          CustomTextField(
                            onTap: () {
                              Get.to(SetOnMapScreen());
                            },
                            controller: controller.locationTEController,
                            prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
                            suffixIcon: Icon(CupertinoIcons.search_circle),
                            hintText: L10n.tr.whereAreYouHeadedHint,
                            borderColor: AppColors.primaryColor,
                            borderRadio: 20,
                            onChanged: (address) {
                              getCoordinates(address);
                            },
                          ),

                          SizedBox(height: 8),
                          Padding(
                            padding:  EdgeInsets.fromLTRB(16.sp,16.sp,16.sp,0.sp),
                            child: Row(
                              children: [
                                Text(L10n.tr.savedAddressLabel, style:  TextStyle(fontSize: 18.sp),),
                                Spacer(),
                                Text(L10n.tr.seeAllLink, style:  TextStyle(fontSize: 15.sp,color: AppColors.greenShade50),)
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomLocationButton(
                                      imageUrl: AppImage.home,
                                      mainText: L10n.tr.homeOption,
                                      subText: L10n.tr.setAddressSubtitle,
                                      onTap: () {
                                        print('Location button tapped');
                                        Get.to(SetLocationOptionPage());
                                      },
                                    ),
                                    VerticalDivider(color: AppColors.white, width: 2),
                                    CustomLocationButton(
                                      imageUrl: AppImage.briefcase,
                                      mainText: L10n.tr.workOption,
                                      subText: L10n.tr.setAddressSubtitle,
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
              Positioned(
                top: 40,
                left: 16,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
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
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FindCarBottomSheet(); // Call the custom bottom sheet widget here
                },
              );
            },
            title: Text(
              L10n.tr.continueButton,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
