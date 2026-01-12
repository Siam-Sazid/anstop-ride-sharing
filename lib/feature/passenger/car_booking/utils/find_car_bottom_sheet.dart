import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/accept_car_bottom_sheet.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/payment_method_dropdown.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
class FindCarBottomSheet extends StatefulWidget {
  @override
  _FindCarBottomSheetState createState() => _FindCarBottomSheetState();
}

class _FindCarBottomSheetState extends State<FindCarBottomSheet> {
  final TextEditingController locationTEController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int childrenCount = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
         SizedBox(
           height: 268.h,
           width: 345.w,
           child: Card(
             color: AppColors.white,
             elevation: 5,
             child: Padding(
               padding:  EdgeInsets.all(16.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(AppLocalization.tr.yourTripLabel,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                   SizedBox(height: 8.sp,),
                   Row(children: [
                     Container(
                       child: Image.asset(AppImage.greetings),
                     ),
                     SizedBox(width: 5.sp,),
                     Text(AppLocalization.tr.pickupLocationExample),

                   ],),
                   SizedBox(height: 8.sp,),
                   Row(children: [
                     Container(
                       child: Icon(Icons.location_on,color: AppColors.primaryColor,),
                     ),
                     SizedBox(width: 5.sp,),
                     Text(AppLocalization.tr.dropoffLocationExample),

                   ],),
                   SizedBox(height: 8.sp,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                     Text(
                      AppLocalization.tr.distanceLabel,style: TextStyle(
                       fontSize: 18.sp,color: Colors.black
                     ),
                     ),
                     SizedBox(width: 5.sp,),
                     Text(AppLocalization.tr.distanceExample),

                   ],),
                SizedBox(height: 8.h,),

                   Text(
                     'Enter Ride Price',style: TextStyle(
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
                 ],
               ),
             ),
           ),
         ),

          SizedBox(height: 16.sp),
          Text(
            'Payment Method',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.sp),

          PaymentMethodDropdown(),
          SizedBox(height: 10.sp),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayShade100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Row(
                children: [
                  Text(
                    'Children',
                    style: TextStyle(fontSize: 18.sp, color: AppColors.primaryColor),
                  ),
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            childrenCount++;
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_up_outlined,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (childrenCount > 0) childrenCount--;
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '$childrenCount',
                    style: TextStyle(fontSize: 15.sp, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.sp),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayShade100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: AppLocalization.tr.noteToDriverHint,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 12.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20.sp,),
          CustomButton(
            height: 50,
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
              'Find Car',
             // L10n.tr.,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
