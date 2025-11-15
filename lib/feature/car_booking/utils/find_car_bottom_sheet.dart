import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/car_booking/utils/accept_car_bottom_sheet.dart';
import 'package:ride_sharing/feature/car_booking/utils/payment_method_dropdown.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:get/get.dart';
class FindCarBottomSheet extends StatefulWidget {
  @override
  _FindCarBottomSheetState createState() => _FindCarBottomSheetState();
}

class _FindCarBottomSheetState extends State<FindCarBottomSheet> {
  final TextEditingController locationTEController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController(); // Controller for the description text field

  int childrenCount = 0; // Default number of children
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // Adjust height as needed
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
         Card(
           color: AppColors.white,
           elevation: 5,
           child: Padding(
             padding:  EdgeInsets.all(16.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Your Trip',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
                 SizedBox(height: 8.sp,),
                 Row(children: [
                   Container(
                     child: Image.asset('assets/images/greetings.png'),
                   ),
                   SizedBox(width: 5.sp,),
                   Text('Block b / Banasree, Dhaka'),

                 ],),
                 SizedBox(height: 8.sp,),
                 Row(children: [
                   Container(
                     child: Icon(Icons.location_on,color: AppColors.primaryColor,),
                   ),
                   SizedBox(width: 5.sp,),
                   Text('Green Road Dhaka'),

                 ],),
                 SizedBox(height: 8.sp,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                   Text(
                    'Distance',style: TextStyle(
                     fontSize: 18.sp,color: Colors.black
                   ),
                   ),
                   SizedBox(width: 5.sp,),
                   Text('89 km'),

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

          SizedBox(height: 16.sp),
          Text(
            'Payment Method',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.sp),

          // Dropdown to select payment method
          PaymentMethodDropdown(),
          SizedBox(height: 10.sp),
          Container(
          //  height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayShade100), // Set border color
              borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners if desired
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:  10.sp),
              child: Row(
                children: [
                  Text('Children', style: TextStyle(fontSize: 18.sp, color: AppColors.primaryColor)),
                  Spacer(),
                  Column(

                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up, color: AppColors.primaryColor), // Up arrow
                        onPressed: () {
                          setState(() {
                            childrenCount++;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor), // Down arrow
                        onPressed: () {
                          setState(() {
                            if (childrenCount > 0) childrenCount--; // Prevent going negative
                          });
                        },
                      ),
                    ],
                  ),
                  Text('$childrenCount', style: TextStyle(fontSize: 15.sp, color: AppColors.primaryColor)),

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
                hintText: 'Give a short note to the driver,',
                contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 12.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20.sp,),
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
              'Find Car',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
