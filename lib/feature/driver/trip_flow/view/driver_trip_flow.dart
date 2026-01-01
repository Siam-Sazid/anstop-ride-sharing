import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/widgets/custom_horizontal_line.dart';
import 'package:ride_sharing/widgets/custom_vertical_line.dart';

// import your app colors here
// import '../../../../app/message_utils/app_colors.dart';

// Mock colors - replace with your actual AppColors


// Trip model
class TripRequest {
  final String id;
  final String passengerName;
  final String passengerImage;
  final double rating;
  final String pickupTime;
  final String pickupLocation;
  final String dropoffLocation;
  final double fare;
  final double distance;
  final String vehicleType;
  final String note;

  TripRequest({
    required this.id,
    required this.passengerName,
    required this.passengerImage,
    required this.rating,
    required this.pickupTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.distance,
    required this.vehicleType,
    required this.note,
  });
}

// Trip states enum
enum TripState {
  pendingRequests,
  tripDetail,
  bidding,
  tripTaken,
  tripAccepted,
  activeTrip, dropOffArrived, dropOffNavigation,
}

// Driver trip controller
class DriverTripController extends GetxController {
  final Rx<TripState> currentState = TripState.pendingRequests.obs;
  final RxList<TripRequest> pendingTrips = <TripRequest>[].obs;
  final Rx<TripRequest?> selectedTrip = Rx<TripRequest?>(null);
  final RxDouble bidAmount = 0.0.obs;
  final TextEditingController bidController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    pendingTrips.value = [
      TripRequest(
        id: '1',
        passengerName: 'Jane Cooper',
        passengerImage: 'assets/images/passenger1.jpg',
        rating: 4.9,
        pickupTime: '4:40 PM • 5 min',
        pickupLocation: '1011 Biggen St, Epping Glentworth 63936',
        dropoffLocation: '9971 W Anuy St, Lirica Plunguyekia 87861',
        fare: 100,
        distance: 3.3,
        vehicleType: 'Comfortable Sedans',
        note: 'Please call when you arrive at gate',
      ),
      // Add more mock trips...
    ];
  }

  void selectTrip(TripRequest trip) {
    selectedTrip.value = trip;
    currentState.value = TripState.tripDetail;
  }

  void showBiddingScreen() {
    currentState.value = TripState.bidding;
  }

  void submitBid() {
    if (bidAmount.value > 0) {
      // Simulate trip being taken by another driver sometimes
      if (DateTime.now().millisecond % 2 == 0) {
        currentState.value = TripState.tripTaken;
      } else {
        currentState.value = TripState.tripAccepted;
      }
    }
  }

  void acceptTrip() {
    currentState.value = TripState.tripAccepted;
  }

  void startTrip() {
    currentState.value = TripState.activeTrip;
  }

  void startDropOff() {
    currentState.value = TripState.dropOffNavigation;
  }

  void arrivedAtDestination() {
    currentState.value = TripState.dropOffArrived;
  }

  void completeTrip() {
    currentState.value = TripState.pendingRequests;
    selectedTrip.value = null;
  }

  void searchAgain() {
    currentState.value = TripState.pendingRequests;
    selectedTrip.value = null;
  }

  void confirmPickup() {
    startTrip();
  }

  @override
  void onClose() {
    bidController.dispose();
    super.onClose();
  }
}

// Main trip flow widget
class DriverTripFlow extends StatelessWidget {
  const DriverTripFlow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverTripController>(
      init: DriverTripController(),
      builder: (controller) {
        return Obx(() {
          switch (controller.currentState.value) {
            case TripState.pendingRequests:
              return const PendingTripsBottomSheet();
            case TripState.tripDetail:
              return const TripDetailBottomSheet();
            case TripState.bidding:
              return const BiddingBottomSheet();
            case TripState.tripTaken:
              return const TripTakenBottomSheet();
            case TripState.tripAccepted:
              return const TripAcceptedBottomSheet();
            case TripState.activeTrip:
              return const ActiveTripBottomSheet();
            case TripState.dropOffNavigation:
              return const DropOffNavigationBottomSheet();
            case TripState.dropOffArrived:
              return const DropOffArrivedBottomSheet();
          }
        });
      },
    );
  }
}

// 1. Pending Trips List (Image 1)
class PendingTripsBottomSheet extends StatelessWidget {
  const PendingTripsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.pendingTrips.length,
              itemBuilder: (context, index) {
                final trip = controller.pendingTrips[index];
                return TripRequestCard(
                  trip: trip,
                  onTap: () => controller.selectTrip(trip),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}

class TripRequestCard extends StatelessWidget {
  final TripRequest trip;
  final VoidCallback onTap;

  const TripRequestCard({
    Key? key,
    required this.trip,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     // height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Passenger info
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage(trip.passengerImage),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.passengerName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.tesxtColor,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) => Icon(
                              Icons.star,
                              size: 12.sp,
                              color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                            )),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            trip.rating.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      trip.pickupTime,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.tesxtColor,
                      ),
                    ),
                    Text(
                      trip.vehicleType,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Fare and distance
            Row(
              children: [
                Text(
                  'Fare',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tesxtColor,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '\$${trip.fare.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${trip.distance} km',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Locations
            Container(
              decoration: BoxDecoration(
                color: Colors.white,                      // background (change if needed)
                borderRadius: BorderRadius.circular(16.r), // rounded corners
                border: Border.all(
                  color: Colors.grey.shade300,            // grey border
                  width: 1,
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.asset(AppImage.passenger),
                        SizedBox(height: 4.h),
                       CustomVerticalLine(height: 30.h, color: Colors.black),
                        SizedBox(height: 4.h),
                        Icon(Icons.location_on,color: AppColors.togglebuttonColor,)
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick up',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.pickupLocation,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Drop off',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.dropoffLocation,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColors.grayShade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Bid',
                      style: TextStyle(
                        color: AppColors.appGreyColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Trip Detail (Image 2)
class TripDetailBottomSheet extends StatelessWidget {
  const TripDetailBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Container(
      height:600.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 10.sp,bottom: 16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoWidget(
                  width: 40.0,
                  height: 40.0,
                  fontSize: 15.sp,
                ),
                IconButton(
                        onPressed: () => controller.searchAgain(),
                        icon: Icon(Icons.close),
                      ),
              ],
            ),
          ),
          // Close button
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: EdgeInsets.only(right: 16.w),
          //     child: IconButton(
          //       onPressed: () => controller.searchAgain(),
          //       icon: Icon(Icons.close),
          //     ),
          //   ),
          // ),

          // Passenger info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: AssetImage(trip.passengerImage),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.passengerName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.tesxtColor,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) => Icon(
                              Icons.star,
                              size: 14.sp,
                              color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                            )),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(${trip.rating})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${trip.fare.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      '${trip.distance} km',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:  10.sp ),
            child: CustomHorizontalLine(
              thickness: 2.sp,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 24.h),

          // Locations
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick up',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.pickupLocation,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop off',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.dropoffLocation,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:  10.sp ),
            child: CustomHorizontalLine(
              thickness: 2.sp,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 24.h),

          // Passenger note
          if (trip.note.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passenger\'s Note',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tesxtColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trip.note,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

         // const Spacer(),
          SizedBox(height: 16.h,),
          // Action buttons
          Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => controller.acceptTrip(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                     // padding: EdgeInsets.symmetric(vertical: 20.h), // increased height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      'Accept Offer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp, // increased size
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h), // spacing between buttons

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () => controller.showBiddingScreen(),
                    style: OutlinedButton.styleFrom(
                    //  padding: EdgeInsets.symmetric(vertical: 20.h), // increased height
                      side: BorderSide(color: AppColors.grayShade100, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      'Bid',
                      style: TextStyle(
                        color: AppColors.grayShade100,
                        fontSize: 18.sp, // increased size
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}

// 3. Bidding Screen (Image 3)
class BiddingBottomSheet extends StatelessWidget {
  const BiddingBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Container(
      height: 450.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Close button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconButton(
                onPressed: () => controller.searchAgain(),
                icon: Icon(Icons.close),
              ),
            ),
          ),

          // Passenger info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: AssetImage(trip.passengerImage),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.passengerName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.tesxtColor,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) => Icon(
                              Icons.star,
                              size: 14.sp,
                              color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                            )),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(${trip.rating})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${trip.fare.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      '${trip.distance} km',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Locations
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick up',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.pickupLocation,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop off',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Text(
                            trip.dropoffLocation,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Bid price input
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Put your offer price',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tesxtColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.tesxtColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: controller.bidController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.tesxtColor,
                          ),
                          decoration: InputDecoration(
                            hintText: '60',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            controller.bidAmount.value = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Submit button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.submitBid(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Trip Taken by Another Driver (Image 4)
class TripTakenBottomSheet extends StatelessWidget {
  const TripTakenBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 32.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Text(
            'The trip has been accepted\nby another rider.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.tesxtColor,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            'Please search again.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 32.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.searchAgain(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Search Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Trip Accepted - Pickup Location (Image 5)
class TripAcceptedBottomSheet extends StatelessWidget {
  const TripAcceptedBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Pickup location',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.tesxtColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,color: AppColors.togglebuttonColor,) ,
                      Text(
                        trip.pickupLocation,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      onPressed: () => controller.confirmPickup(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                       // padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'Confirm Pickup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// 6. Active Trip with Navigation (Image 6)
class ActiveTripBottomSheet extends StatelessWidget {
  const ActiveTripBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Navigation banner

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(0),
          ),
          margin: EdgeInsets.symmetric(vertical: 75.sp),
          child: Row(
            children: [
              Icon(
                Icons.navigation,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                '200 m    Turn right at block b, road no 18',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Bottom sheet
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Trip status
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.grayShade100,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    'You are on a trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tesxtColor,
                    ),
                  ),
                ),
              ),


              SizedBox(height: 16.h),

              // Passenger info
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: AssetImage(trip.passengerImage),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.passengerName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.tesxtColor,
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (i) => Icon(
                                  Icons.star,
                                  size: 14.sp,
                                  color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                                )),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${trip.rating})',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${trip.fare.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          '${trip.distance} km',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:  16.sp),
              child: CustomHorizontalLine(thickness: 2,color: AppColors.grayShade100,),
            ),
              SizedBox(height: 24.h),

              // Trip details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Pick Up',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tesxtColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Drop off',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tesxtColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Block B, Banasree, Dhaka.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            'Dhanmondi, Dhaka',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Passenger note
              if (trip.note.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passenger\'s Note',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.tesxtColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trip.note,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 24.h),

              // Accept offer button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.startDropOff(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Accept Offer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DropOffNavigationBottomSheet extends StatelessWidget {
  const DropOffNavigationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0.r)),
      ),
      child: Padding(
        padding:  EdgeInsets.all(16.sp),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          SizedBox(height: 10.h,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Passenger info
                    // Passenger info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: AssetImage(trip.passengerImage),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.passengerName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tesxtColor,
                                ),
                              ),
                             // SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      Icons.star,
                                      size: 12.sp,
                                      color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                                    )),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '5.0',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                   // SizedBox(height: 16.h),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 16.h),

                    // Trip info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pick Up',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                'Block B, Banasree, Dhaka',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.tesxtColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Drop off',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Dhanmondi, Dhaka',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.tesxtColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Time, Distance, Fare
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'EST',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '6 min',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.tesxtColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Distance',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '3.3 km',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.tesxtColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Fare',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '\$ 24',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.tesxtColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Drop Off Button
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:  16.sp),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () => controller.arrivedAtDestination(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenShade300,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text(
                            'Drop Off',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    CustomHorizontalLine(thickness: 2,),
                    SizedBox(height: 20.h),
                    // Navigation directions
                    Expanded(
                      child: ListView(
                        children: [
                          NavigationStep(
                            icon: Icons.straight,
                            instruction: 'Head west on Road No. 3',
                            distance: '240 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_left,
                            instruction: 'Turn left onto Ave 3',
                            distance: '80 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_right,
                            instruction: 'Turn right onto Road No. 5',
                            distance: '400 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_left,
                            instruction: 'Turn left',
                            distance: '110 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_right,
                            instruction: 'Turn right at Titas Gas Rd',
                            distance: '160 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_left,
                            instruction: 'Turn left',
                            distance: '130 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_right,
                            instruction: 'Turn right at Rampura',
                            distance: '160 m',
                          ),
                          NavigationStep(
                            icon: Icons.turn_right,
                            instruction: 'Turn right',
                            distance: '400 m',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Drop-off Arrived with Navigation Banner (Image 2)
class DropOffArrivedBottomSheet extends StatelessWidget {
  const DropOffArrivedBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();
    final trip = controller.selectedTrip.value!;

    return Column(
      children: [
        // Navigation banner at top
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.symmetric(vertical:  70.w),
          child: Row(
            children: [
              Icon(
                Icons.navigation,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '200 m    Turn right at block b, road no 18',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom sheet content (same as previous screen)
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        // Passenger info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundImage: AssetImage(trip.passengerImage),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                trip.passengerName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tesxtColor,
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (i) => Icon(
                                Icons.star,
                                size: 12.sp,
                                color: i < trip.rating.floor() ? Colors.amber : Colors.grey[300],
                              )),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '5.0',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                        Divider(color: Colors.grey[300]),
                        SizedBox(height: 16.h),

                        // Trip info
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pick Up',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Block B, Banasree, Dhaka',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.tesxtColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drop off',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Dhanmondi, Dhaka',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.tesxtColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Time, Distance, Fare
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'EST',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '6 min',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.tesxtColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Distance',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '3.3 km',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.tesxtColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Fare',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\$ 24',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.tesxtColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Drop Off Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.completeTrip(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Drop Off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Navigation directions
                        Expanded(
                          child: ListView(
                            children: [
                              NavigationStep(
                                icon: Icons.straight,
                                instruction: 'Head west on Road No. 3',
                                distance: '240 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_left,
                                instruction: 'Turn left onto Ave 3',
                                distance: '80 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_right,
                                instruction: 'Turn right onto Road No. 5',
                                distance: '400 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_left,
                                instruction: 'Turn left',
                                distance: '110 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_right,
                                instruction: 'Turn right at Titas Gas Rd',
                                distance: '160 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_left,
                                instruction: 'Turn left',
                                distance: '130 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_right,
                                instruction: 'Turn right at Rampura',
                                distance: '160 m',
                              ),
                              NavigationStep(
                                icon: Icons.turn_right,
                                instruction: 'Turn right',
                                distance: '400 m',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Navigation step widget
class NavigationStep extends StatelessWidget {
  final IconData icon;
  final String instruction;
  final String distance;

  const NavigationStep({
    Key? key,
    required this.icon,
    required this.instruction,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.tesxtColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instruction,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.tesxtColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      distance,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomHorizontalLine(thickness: 2,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}












