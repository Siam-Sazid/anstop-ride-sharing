import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/driver/invoice/view/invoice_view.dart';
import 'package:ride_sharing/utils/user_info_section.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_vertical_line.dart';

import '../../../../utils/custom_download_tile.dart';

class DriverCompletedTripDetails extends StatelessWidget {
  const DriverCompletedTripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(AppString.tripDetailsTitle),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Map image container
            Card(
              elevation: 2,
              child: ClipRRect(

                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text(AppString.mapImageNotAvailable));
                  },
                ),
              ),
            ),

            SizedBox(height: 20),
            Card(
              elevation: 2,
              color: AppColors.white,
              child: Container(
                height: 85.h,
                child: Padding(
                  padding:  EdgeInsets.all(16.sp),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(AppString.passengerNameExample,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(AppString.dateExample,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(AppString.completedStatus,style: TextStyle(color: Colors.green),),
                          Spacer(),
                          Text(AppString.timeExample) ,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /// Add other trip detail widgets here...
            Card(
              color: AppColors.white,
              elevation: 2,
              child: Padding(
                padding:  EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.yourTripLabel,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 8.sp,),
                    Row(children: [
                      Container(
                        child: Image.asset(AppImage.greetings),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(AppString.pickupLocationExample),

                    ],),
                    CustomVerticalLine(height: 20.h, color: Colors.black),
                    Row(children: [
                      Container(
                        child: Icon(Icons.location_on,color: AppColors.primaryColor,),
                      ),
                      SizedBox(width: 5.sp,),
                      Text(AppString.dropoffLocationExample),

                    ],),
                    SizedBox(height: 8.sp,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.distanceLabel,style: TextStyle(
                            fontSize: 18.sp,color: Colors.black
                        ),
                        ),
                        SizedBox(width: 5.sp,),
                        Text(AppString.distanceExample),

                      ],),
                    SizedBox(height: 8.h,),


                    // SizedBox(height: 8.h,),

                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),

            SizedBox(height: 8.h),
            Card(
              elevation: 2,
              color: AppColors.white,
              child: Container(
                height: 50.h,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:  16.sp),
                  child: Row(
                    children: [
                      Text(AppString.rideValueLabel),
                      Spacer(),
                      Text(AppString.fareExample2) ,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:  8.sp),
              child: Container(
              //  height: 70.h,
                color: AppColors.white,
                child: UserInfoSection(
                  imageUrl: 'https://picsum.photos/250?image=9',
                  name: 'John Doe',
                  rating: 3.54,
                  trips: 3,
                  profession: 'Professional',
                  price: '\$24',
                  distance: '28 km',
                ),
              ),
            ),
            SizedBox(height: 5.h,),
            DownloadRideScriptTile(
              onTap: () {
                // your function here
               // controller.downloadRideScript();
                Get.to(InvoicePage());
              },
              iconColor: AppColors.togglebuttonColor,
              iconSize: 15.sp,
            )
          ],
        ),
      ),
    );
  }
}
