import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/car_details.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/driver_status_widget.dart';
import 'package:ride_sharing/feature/passenger/car_booking/utils/ride_begun_bottom_sheet.dart';
import 'package:ride_sharing/utils/user_info_section.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/passenger/payment/view/passenger_payment_screen.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';

class DriverArrivedBottomSheet extends StatefulWidget {
  @override
  _DriverArrivedBottomSheetState createState() => _DriverArrivedBottomSheetState();
}

class _DriverArrivedBottomSheetState extends State<DriverArrivedBottomSheet> {
  int rating = 0;
  @override

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.only(top: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          DriverStatusWidget(
            statusText: 'Driver has been arrived',
            circleColor: Colors.green,
          ),

          // SizedBox(height: 16.sp),
          CarDetailsWidget(
            title: 'DHK METRO - 8475Dkk',
            subtitle: 'Toyota',
            imagePath: AppImage.carsSideView,
            backgroundColor: AppColors.greenShade50,
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
          SizedBox(height: 16.sp),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:  16.sp),
            child: CustomButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    // Navigator.pop(context);
                    return GestureDetector(
                      onTap: (){

                        Get.offAll(() => PassengerPaymentScreen());
                      },
                        child: RideBegunBottomSheet()

                    );

                  },
                );
              },
              title: Text(
                'Lets Ride',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
