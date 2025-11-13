import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/homepage/passenger/controller/home_page_controller.dart';
import 'package:ride_sharing/feature/set_location/controller/set_location_controller.dart';
import 'package:ride_sharing/feature/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/widgets/custom_google_map.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationScreen extends StatelessWidget {
  const SetLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarTitle(),
      body: GetBuilder<SetLocationController>(
        builder: (controller) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: SetLocationController.defaultLocation,
                onMapCreated: controller.onMapCreated, // Pass the controller
                markers: controller.markers,
              ),
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
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
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
                              controller: controller.locationTEController,
                              prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
                              suffixIcon: Icon(CupertinoIcons.search_circle),
                              hintText: 'Where are you headed?',
                              borderColor: AppColors.primaryColor,
                              borderRadio: 20,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: CustomButton(

                                      onPressed: (){},
                                     title: Text('Set Location',style: TextStyle(color: AppColors.white),),



                                  ),
                                ),
                                Icon(CupertinoIcons.bookmark_fill,color: AppColors.primaryColor,)
                              ],
                              
                            )
                            
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
