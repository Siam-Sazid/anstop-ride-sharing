import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
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
import 'package:ride_sharing/app/utils/app_colors.dart';

class PickUpLocationScreen extends StatelessWidget {
  PickUpLocationScreen({Key? key}) : super(key: key);
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 120.w,
                                height: 70.h,
                                decoration: BoxDecoration(
                                  color: AppColors.greenShade50,
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
                              padding: EdgeInsets.symmetric(horizontal: 8.sp),
                              child: Text(AppLocalization.tr.yourPickUpPointLabel),
                            ),
                            // Pickup Location - Google Place Autocomplete
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: AppColors.primaryColor),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: controller.pickUpAddressController,
                                      googleAPIKey: AppLocalization.tr.googleApiKey,
                                      inputDecoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalization.tr.whereAreYouHeadedHint,
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.appGreyColor,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.darkColor,
                                      ),
                                      debounceTime: 200,
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng: (Prediction prediction) {
                                        if (prediction.lat != null && prediction.lng != null) {
                                          controller.pickUpLatitudeController.text = prediction.lat.toString();
                                          controller.pickUpLongitudeController.text = prediction.lng.toString();
                                          controller.updateMapMarkers();
                                        }
                                      },
                                      itemClick: (Prediction prediction) {
                                        controller.pickUpAddressController.text = prediction.description ?? "";
                                        FocusScope.of(context).unfocus();
                                      },
                                      containerHorizontalPadding: 0,
                                      itemBuilder: (context, index, Prediction prediction) {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors.primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  prediction.description ?? "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: AppColors.darkColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      isCrossBtnShown: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.sp),
                              child: Text(AppLocalization.tr.yourDestinationLabel),
                            ),
                            // Destination Location - Google Place Autocomplete
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: AppColors.primaryColor),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: controller.destinationAddressController,
                                      googleAPIKey: AppLocalization.tr.googleApiKey,
                                      inputDecoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalization.tr.whereAreYouHeadedHint,
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.appGreyColor,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.darkColor,
                                      ),
                                      debounceTime: 200,
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng: (Prediction prediction) {
                                        if (prediction.lat != null && prediction.lng != null) {
                                          controller.destinationLatitudeController.text = prediction.lat.toString();
                                          controller.destinationLongitudeController.text = prediction.lng.toString();
                                          controller.updateMapMarkers();
                                        }
                                      },
                                      itemClick: (Prediction prediction) {
                                        controller.destinationAddressController.text = prediction.description ?? "";
                                        FocusScope.of(context).unfocus();
                                      },
                                      containerHorizontalPadding: 0,
                                      itemBuilder: (context, index, Prediction prediction) {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors.primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  prediction.description ?? "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: AppColors.darkColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      isCrossBtnShown: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 0.sp),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalization.tr.savedAddressLabel,
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    AppLocalization.tr.seeAllLink,
                                    style: TextStyle(fontSize: 15.sp, color: AppColors.greenShade50),
                                  )
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
                                        mainText: AppLocalization.tr.homeOption,
                                        subText: AppLocalization.tr.setAddressSubtitle,
                                        onTap: () {
                                          print('Location button tapped');
                                          Get.to(SetLocationOptionPage());
                                        },
                                      ),
                                      VerticalDivider(color: AppColors.white, width: 2),
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
                            SizedBox(height: 8),
                          ],
                        ),
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
      bottomNavigationBar: GetBuilder<PickUpLocationController>(
        builder: (controller) {
          return BottomAppBar(
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: CustomButton(
                onPressed: controller.isCalculatingFare
                    ? null
                    : () async {
                        // Calculate fare before showing the bottom sheet
                        bool success = await controller.calculateFare();
                        if (success) {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return FindCarBottomSheet(
                                pickUpAddress: controller.pickUpAddressController.text,
                                destinationAddress: controller.destinationAddressController.text,
                                distance: controller.calculatedDistance,
                                fare: controller.calculatedFare,
                              );
                            },
                          );
                        }
                      },
                title: controller.isCalculatingFare
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Next",
                        style: TextStyle(color: AppColors.white),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
