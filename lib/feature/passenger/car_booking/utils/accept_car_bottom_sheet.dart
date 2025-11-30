import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/widgets/custom_button.dart';
import 'package:ride_sharing/widgets/custom_text_field.dart';
import 'package:ride_sharing/widgets/logo.dart';

import 'find_nearby_cars_bottom_sheet.dart';
class AcceptCarBottomSheet extends StatefulWidget {
  @override
  _AcceptCarBottomSheetState createState() => _AcceptCarBottomSheetState();
}

class _AcceptCarBottomSheetState extends State<AcceptCarBottomSheet> {
  final TextEditingController locationTEController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isAcceptClicked = false;
  int childrenCount = 0;
  int rating = 0;
  Future<double> calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    double distanceInMeters = await Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LogoWidget(
                width: 40.w,
                height: 40.h,
                fontSize: 15.sp,
              ),
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.greenShade50,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 16.sp),

          Row(
            children: [
              ClipOval(
                child: Image.network(
                  'https://picsum.photos/250?image=9',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.sp),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  // Compact rating stars
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: index < rating
                              ? Colors.yellow
                              : Colors.grey,
                          size: 16.sp,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$24"),
                  Text('28 km')
                  
                ],
              )
            ],
          ),

          Divider(
            color: AppColors.grayShade100,  // Divider color
            thickness: 1,  // Divider thickness
            indent: 0,  // Left indent (optional)
            endIndent: 0,  // Right indent (optional)
          ),

          SizedBox(height: 8.sp,),
          Row(children: [
            Container(
              child: Image.asset('assets/images/greetings.png'),
            ),
            SizedBox(width: 5.sp,),
            Text('Block b / Banasree, Dhaka'),

          ],),
          SizedBox(height: 8.sp,),
          SizedBox(width: 12.sp),
          Container(
            height: 20.h,
            width: 2,
            color: Colors.black,
          ),

          Row(children: [
            Container(
              child: Icon(Icons.location_on,color: AppColors.primaryColor,),
            ),
            SizedBox(width: 5.sp,),
            Text('Green Road Dhaka'),

          ],
          ),
          Divider(
            color: AppColors.grayShade100,  // Divider color
            thickness: 1,  // Divider thickness
            indent: 0,  // Left indent (optional)
            endIndent: 0,  // Right indent (optional)
          ),

          Row(
            children: [
              Text('Previous Price',style: TextStyle(fontSize: 20.sp),),
              Spacer(),
              Text('\$20',style: TextStyle(fontSize: 20.sp),),

            ],
          ),

          SizedBox(height: 8.h,),
          if (!isAcceptClicked) ...[
            CustomButton(
              onPressed: () {
                setState(() {
                  isAcceptClicked = true; // Mark Accept clicked
                });
              },
              title: Text(
                'Accept',
                style: TextStyle(color: AppColors.white),
              ),
            ),
            SizedBox(height: 15.h),
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AcceptCarBottomSheet();
                  },
                );
              },
              title: Text(
                'Bid',
                style: TextStyle(color: Colors.grey),
              ),
              backgroundColor: AppColors.white,
              bordersColor: Colors.grey,
            ),
          ] else ...[
            Text(
              'Put your Offer Price',style: TextStyle(
                fontSize: 18.sp,color: AppColors.appGreyColor
            ),
            ),
            // SizedBox(height: 8.h,),
            CustomTextField(
              onTap: () {
                //   Get.to(SetOnMapScreen());
              },

              //  prefixIcon: Icon(Icons.location_on, color: AppColors.primaryColor),
              //  suffixIcon: Icon(CupertinoIcons.search_circle),
              //  hintText: 'Where are you headed?',
              borderColor: AppColors.grayShade100,
              borderRadio: 10,
              controller: locationTEController,
            ),
            SizedBox(height: 10.h,),
            CustomButton(
              onPressed: () {
                // Handle Submit action here
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FindNearbyCarsBottomSheet();
                  },
                );
              },
              title: Text(
                'Submit',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}