import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/widgets/custom_button.dart';
import 'package:ride_sharing/widgets/logo.dart';
import 'package:ride_sharing/services/socket_services.dart';

import 'find_nearby_cars_bottom_sheet.dart';

class NearbyDriver {
  final String id;
  final String name;
  final String email;
  final String locationName;
  final double distance;
  final List<double> coordinates;

  NearbyDriver({
    required this.id,
    required this.name,
    required this.email,
    required this.locationName,
    required this.distance,
    required this.coordinates,
  });

  factory NearbyDriver.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coords = location?['coordinates'] as List<dynamic>? ?? [0.0, 0.0];

    return NearbyDriver(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      locationName: json['locationName'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      coordinates: coords.map((e) => (e as num).toDouble()).toList(),
    );
  }
}

class AcceptCarBottomSheet extends StatefulWidget {
  final String pickUpAddress;
  final String destinationAddress;
  final List<dynamic>? initialDriversData;

  const AcceptCarBottomSheet({
    Key? key,
    required this.pickUpAddress,
    required this.destinationAddress,
    this.initialDriversData,
  }) : super(key: key);

  @override
  _AcceptCarBottomSheetState createState() => _AcceptCarBottomSheetState();
}

class _AcceptCarBottomSheetState extends State<AcceptCarBottomSheet> {
  List<NearbyDriver> nearbyDrivers = [];
  bool isLoading = true;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initDriversData();
    _initSocketAndListen();
  }

  void _initDriversData() {
    // If initial data is provided, use it immediately
    if (widget.initialDriversData != null && widget.initialDriversData!.isNotEmpty) {
      _logger.i('Using initial drivers data: ${widget.initialDriversData!.length} drivers');
      nearbyDrivers = widget.initialDriversData!
          .map((driverJson) => NearbyDriver.fromJson(driverJson as Map<String, dynamic>))
          .toList();
      isLoading = false;
      _logger.i('Initialized with ${nearbyDrivers.length} drivers');
    }
  }

  Future<void> _initSocketAndListen() async {
    final socketService = SocketIoService.to;

    _logger.i('Current socket status - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');

    // Ensure socket is connected
    if (!socketService.isConnected.value) {
      _logger.i('Socket not connected, connecting...');
      await socketService.connect();

      // Wait a bit for connection to establish
      await Future.delayed(const Duration(milliseconds: 500));
      _logger.i('After connect - isConnected: ${socketService.isConnected.value}, isSocketReady: ${socketService.isSocketReady}');
    }

    _logger.i('Setting up listener for nearest-drivers event (for future updates)');

    // Use the dedicated method for nearest-drivers (for future updates)
    socketService.onNearestDrivers((data) {
      _logger.i('Received nearest-drivers event in AcceptCarBottomSheet: $data');

      if (data != null) {
        List<dynamic> driversList;

        // Handle both List and other formats
        if (data is List) {
          driversList = data;
        } else if (data is Map && data['data'] is List) {
          driversList = data['data'] as List;
        } else {
          _logger.e('Unexpected data format: ${data.runtimeType}');
          return;
        }

        if (mounted) {
          setState(() {
            nearbyDrivers = driversList
                .map((driverJson) => NearbyDriver.fromJson(driverJson as Map<String, dynamic>))
                .toList();
            isLoading = false;
          });
          _logger.i('Updated drivers list: ${nearbyDrivers.length} drivers');
        }
      }
    });
  }

  @override
  void dispose() {
    _logger.i('Disposing AcceptCarBottomSheet, removing socket listener');
    SocketIoService.to.offNearestDrivers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Logo and Close button
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

          SizedBox(height: 12.sp),

          // Pickup Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppImage.greetings),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  widget.pickUpAddress.isNotEmpty
                      ? widget.pickUpAddress
                      : 'Pickup location',
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Vertical line connector
          Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Container(
              height: 20.h,
              width: 2,
              color: Colors.black,
            ),
          ),

          // Destination Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.primaryColor),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  widget.destinationAddress.isNotEmpty
                      ? widget.destinationAddress
                      : 'Destination',
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Divider(
            color: AppColors.grayShade100,
            thickness: 1,
          ),

          SizedBox(height: 8.sp),

          // Drivers List
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(height: 16.sp),
                        Text(
                          'Finding nearby drivers...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.appGreyColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : nearbyDrivers.isEmpty
                    ? Center(
                        child: Text(
                          'No drivers available nearby',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.appGreyColor,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: nearbyDrivers.length,
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.grayShade100,
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          final driver = nearbyDrivers[index];
                          return _buildDriverCard(driver);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(NearbyDriver driver) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Column(
        children: [
          Row(
            children: [
              // Static profile image
              ClipOval(
                child: Image.network(
                  'https://picsum.photos/250?image=9',
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.grayShade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.appGreyColor,
                        size: 30.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.sp),

              // Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.sp),
                    // Rating stars (static for now)
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < 4 ? Colors.yellow : Colors.grey,
                          size: 14.sp,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Distance and price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$20',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Text(
                    '${(driver.distance / 1000).toStringAsFixed(1)} km',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.appGreyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.sp),

          // Accept button (smaller size)
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: CustomButton(
              height: 40,
              onPressed: () {
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
                'Accept',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
