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
  final String driverName;
  final String? driverProfilePicture;
  final double driverRating;
  final int driverTotalReviews;
  final String carBrand;
  final String carModel;
  final String licensePlateNumber;
  final String? licensePlatePicture;
  final String bidAmount;
  final String tripDistance;
  final String pickUpAddress;
  final String destinationAddress;

  const DriverArrivedBottomSheet({
    Key? key,
    this.driverName = '',
    this.driverProfilePicture,
    this.driverRating = 0.0,
    this.driverTotalReviews = 0,
    this.carBrand = '',
    this.carModel = '',
    this.licensePlateNumber = '',
    this.licensePlatePicture,
    this.bidAmount = '',
    this.tripDistance = '',
    this.pickUpAddress = '',
    this.destinationAddress = '',
  }) : super(key: key);

  @override
  _DriverArrivedBottomSheetState createState() => _DriverArrivedBottomSheetState();
}

class _DriverArrivedBottomSheetState extends State<DriverArrivedBottomSheet> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    // Use dynamic data or fallback to static
    final displayName = widget.driverName.isNotEmpty ? widget.driverName : 'John Doe';
    final displayImageUrl = widget.driverProfilePicture ?? 'https://picsum.photos/250?image=9';
    final displayRating = widget.driverRating > 0 ? widget.driverRating : 3.54;
    final displayTrips = widget.driverTotalReviews > 0 ? widget.driverTotalReviews : 3;
    final displayPrice = widget.bidAmount.isNotEmpty ? '\$${widget.bidAmount}' : '\$24';
    final displayDistance = widget.tripDistance.isNotEmpty ? '${widget.tripDistance} km' : '28 km';
    final displayCarTitle = widget.licensePlateNumber.isNotEmpty
        ? widget.licensePlateNumber
        : 'DHK METRO - 8475Dkk';
    final displayCarSubtitle = (widget.carBrand.isNotEmpty || widget.carModel.isNotEmpty)
        ? '${widget.carBrand} ${widget.carModel}'.trim()
        : 'Toyota';

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
            title: displayCarTitle,
            subtitle: displayCarSubtitle,
            imagePath: widget.licensePlatePicture ?? AppImage.carsSideView,
            backgroundColor: AppColors.greenShade50,
            isNetworkImage: widget.licensePlatePicture != null && widget.licensePlatePicture!.isNotEmpty,
          ),
          SizedBox(height: 16.sp),
          /// User Info Section with Avatar and Rating
          UserInfoSection(
            imageUrl: displayImageUrl,
            name: displayName,
            rating: displayRating,
            trips: displayTrips,
            profession: 'Professional',
            price: displayPrice,
            distance: displayDistance,
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
                    return GestureDetector(
                      onTap: (){
                        Get.offAll(() => PassengerPaymentScreen());
                      },
                      child: RideBegunBottomSheet(
                        driverName: widget.driverName,
                        driverProfilePicture: widget.driverProfilePicture,
                        driverRating: widget.driverRating,
                        driverTotalReviews: widget.driverTotalReviews,
                        bidAmount: widget.bidAmount,
                        tripDistance: widget.tripDistance,
                        destinationAddress: widget.destinationAddress,
                      ),
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
