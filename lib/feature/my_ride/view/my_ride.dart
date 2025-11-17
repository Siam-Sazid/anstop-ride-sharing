import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/feature/trip_details/view/ongoing_trip_details.dart';
import 'package:ride_sharing/feature/trip_details/view/complete_trip_details.dart';
import 'package:ride_sharing/widgets/custom_app_bar_title.dart';
import 'package:ride_sharing/widgets/custom_drawer.dart';

import '../../../widgets/custom_horizontal_line.dart';
import '../../../widgets/custom_toggle_button.dart';
import '../utils/ride_card.dart';

class MyRidePage extends StatefulWidget {
  MyRidePage({Key? key}) : super(key: key);

  @override
  State<MyRidePage> createState() => _MyRidePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MyRidePageState extends State<MyRidePage> {
  bool isOngoing = true;

  @override
  Widget build(BuildContext context) {

    final ongoingRides = [
      MyRideCardWidget(
        date: "22 Jan 2025",
        time: "10:45 AM",
        pickup: "Uttara Sector 10, Dhaka",
        dropoff: "Mirpur DOHS, Dhaka",
        onViewDetails: () => Get.to(OngoingTripDetails()),
      ),
      MyRideCardWidget(
        date: "23 Jan 2025",
        time: "2:15 PM",
        pickup: "Banani, Dhaka",
        dropoff: "Dhanmondi 27, Dhaka",
        onViewDetails: () => Get.to(OngoingTripDetails()),
      ),
    ];

    final completedRides = [
      MyRideCardWidget(
        date: "10 Jan 2025",
        time: "7:30 AM",
        pickup: "Mohakhali, Dhaka",
        dropoff: "Uttara 12, Dhaka",
        onViewDetails: () => Get.to(CompletedTripDetails()),
      ),
      MyRideCardWidget(
        date: "05 Jan 2025",
        time: "6:10 PM",
        pickup: "Mirpur 1, Dhaka",
        dropoff: "Bashundhara R/A",
        onViewDetails: () => Get.to(CompletedTripDetails()),
      ),
      MyRideCardWidget(
        date: "01 Jan 2025",
        time: "9:00 AM",
        pickup: "Farmgate",
        dropoff: "Gulshan 2",
        onViewDetails: () => Get.to(CompletedTripDetails()),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarTitle(scaffoldKey: _scaffoldKey),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtonsWidget(
              isOngoing: isOngoing,
              onToggleChanged: (value) {
                setState(() => isOngoing = value);
              },
            ),

            CustomHorizontalLine(
              color: AppColors.togglebuttonColor,
              thickness: 1,
            ),
            SizedBox(height: 10.h),


            Expanded(
              child: ListView(
                children: isOngoing ? ongoingRides : completedRides,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
