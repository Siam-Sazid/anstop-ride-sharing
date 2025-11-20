import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/driver_status_widget.dart';
import 'package:ride_sharing/feature/passenger/payment/view/passenger_payment_screen.dart';
import 'package:ride_sharing/utils/user_info_section.dart';
import 'package:get/get.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../../widgets/custom_horizontal_line.dart';


class RideBegunBottomSheet extends StatefulWidget {
  @override
  _RideBegunBottomSheetState createState() => _RideBegunBottomSheetState();
}

class _RideBegunBottomSheetState extends State<RideBegunBottomSheet> {
  int rating = 0;
  void initState() {
    super.initState();
    // Automatically navigate to DriverArrivedBottomSheet after 3 seconds
    _goToNextRoute();
  }

  Future<void> _goToNextRoute() async {
    await Future.delayed(Duration(seconds: 2));
    //  Get.offAll(() => LogInScreen());
    // Get.offAll(() => DriverRegistration());
    // Get.offAll(() => EmailValidationScreen());
    // Get.offAll(() => DriverHomeScreen());
    Get.to(() => PassengerPaymentScreen());

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.only(top: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          DriverStatusWidget(
            statusText: 'Your Ride has begun',
            circleColor: Colors.green,
          ),
          CustomHorizontalLine(thickness: 5.sp,),

        //  SizedBox(height: 16.sp),
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
        //  SizedBox(height: 16.sp),
          CustomHorizontalLine(thickness: 5.sp,),
           Padding(
            padding:  EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Trip',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 2.sp,),
                    Row(
                      children: [
                        Icon(Icons.location_on,color: AppColors.greenShade50,),
                        Text('Green Road Dhaka'),
                      ],
                    ),
                    // SizedBox(height: 8.h,),

                  ],
                ),
               Spacer(),
               Text('5.9 km'),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
