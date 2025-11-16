import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/car_booking/passenger/cancel_taxi.dart';
import 'package:ride_sharing/feature/car_booking/utils/cancel_driver_widget.dart';
import 'package:ride_sharing/feature/car_booking/utils/car_details.dart';
import 'package:ride_sharing/feature/car_booking/utils/driver_arrived_bottom_sheet.dart';
import 'package:ride_sharing/feature/car_booking/utils/driver_status_widget.dart';
import 'package:ride_sharing/feature/car_booking/utils/support_note_widget.dart';
import 'package:ride_sharing/feature/car_booking/utils/trip_id.dart';
import 'package:ride_sharing/feature/car_booking/utils/user_info_section.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_horizontal_line.dart';
import '../../../widgets/custom_vertical_line.dart';
import '../../../widgets/logo.dart';
import 'package:get/get.dart';

class BookingCarsBottomSheet extends StatefulWidget {
  @override
  _BookingCarsBottomSheetState createState() => _BookingCarsBottomSheetState();
}

class _BookingCarsBottomSheetState extends State<BookingCarsBottomSheet> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      color: AppColors.white,
        padding: EdgeInsets.only(top: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          DriverStatusWidget(
            statusText: 'Driver is on the way to pick up',
            time: '1 min',
            circleColor: Colors.green,
          ),

         // SizedBox(height: 16.sp),
          CarDetailsWidget(
            title: 'DHK METRO - 8475Dkk',
            subtitle: 'Toyota',
            imagePath: 'assets/images/cars_side_view.png',
            backgroundColor: AppColors.violetShade,
          ),
          SizedBox(height: 16.sp),
          /// User Info Section with Avatar and Rating
          UserInfoSection(
            imageUrl: 'https://picsum.photos/250?image=9',
            name: 'John Doe',
            rating: 3.54,
            trips: 3,
            profession: 'Professional',
            price: '\$24',
            distance: '28 km',
          ),
          SupportNoteWidget(),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text('Your Trip',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),),
          ),
          Padding(
            padding:  EdgeInsets.all(5.sp),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primaryColor),
                SizedBox(width: 5.sp),
                Text('Green Road, Dhaka'), // Destination location
              ],
            ),
          ),
          CustomHorizontalLine(thickness: 5.sp,),

          SizedBox(height: 8.sp),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset('assets/images/Wallet.png'),
                SizedBox(width: 2.sp,),
                Text('Pay via wallet',style: TextStyle(fontSize: 20.sp),)
              ],
            ),
          ),
          CustomHorizontalLine(thickness: 5.sp,),
          TripIdWidget(),
          CustomHorizontalLine(thickness: 5.sp,),
          // Cancel Button
          CancelDriverWidget(
            onCancelPressed: () {
              // // Custom behavior when cancel button is pressed
              // print("Cancel button pressed!");
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   builder: (BuildContext context) {
              //    // Navigator.pop(context);
              //  //   return DriverArrivedBottomSheet(); // Your bottom sheet widget
              //
              //
              //   },
              // );
              Get.to(() => CancelTaxiScreen());
            },
          ),

        ],
      ),
    );
  }
}
